// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unused_element

import 'package:exercise_management/page/add_workout.dart';
import 'package:exercise_management/page/workout_history.dart';
import 'package:exercise_management/widget/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// اضافه تمرين الرياضيه الصفحه الرئيسيه
class WorkoutTrackerHome extends StatefulWidget {
  const WorkoutTrackerHome({super.key});

  @override
  _WorkoutTrackerHomeState createState() => _WorkoutTrackerHomeState();
}

class _WorkoutTrackerHomeState extends State<WorkoutTrackerHome> {
  final List<Map<String, dynamic>> _workouts = [];
  final List<Map<String, dynamic>> _workoutHistory = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedWorkouts = prefs.getString('workouts');
    if (storedWorkouts != null) {
      setState(() {
        _workouts.addAll(
            List<Map<String, dynamic>>.from(json.decode(storedWorkouts)));
      });
    }
    String? storedHistory = prefs.getString('workoutHistory');
    if (storedHistory != null) {
      setState(() {
        _workoutHistory.addAll(
            List<Map<String, dynamic>>.from(json.decode(storedHistory)));
      });
    }
  }

  Future<void> _saveWorkouts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('workouts', json.encode(_workouts));
    await prefs.setString('workoutHistory', json.encode(_workoutHistory));
  }

  void _addWorkout(Map<String, dynamic> workout) {
    setState(() {
      _workouts.add(workout);
      _saveWorkouts();
    });
  }

  void _editWorkout(int index, Map<String, dynamic> updatedWorkout) {
    setState(() {
      _workoutHistory.add({
        'old': _workouts[index],
        'new': updatedWorkout,
        'timestamp': DateTime.now().toIso8601String(),
      });
      _workouts[index] = updatedWorkout;
      _saveWorkouts();
    });
  }

  void _deleteWorkout(int index) {
    setState(() {
      _workouts.removeAt(index);
      _saveWorkouts();
    });
  }

  void _startAddNewWorkout(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddWorkout(),
      ),
    );

    if (result != null) {
      _addWorkout(result);
    }
  }

  void _startEditWorkout(BuildContext context, int index) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddWorkout(workout: _workouts[index]),
      ),
    );

    if (result != null) {
      _editWorkout(index, result);
    }
  }

  void _viewWorkoutHistory(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => WorkoutHistory(
          history: _workoutHistory,
          clearHistory: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('workoutHistory');
            setState(() {
              _workoutHistory.clear();
            });
            Navigator.pop(context, _workoutHistory);
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _workoutHistory.clear();
      });
    }
  }

  void _clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('workoutHistory');
    setState(() {
      _workoutHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'إدارة التمارين',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history,
              color: Colors.white,
            ),
            onPressed: () => _viewWorkoutHistory(context),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: _workouts.isEmpty
          ? const Center(
              child: Text(
                'لم تتم إضافة أي تدريبات بعد!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _workouts.length,
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      child: Text('${_workouts[index]['duration']}m'),
                    ),
                    title: Text(
                      _workouts[index]['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'المدة: ${_workouts[index]['duration']} دقيقة\nالتكرارات: ${_workouts[index]['repetitions']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _startEditWorkout(context, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteWorkout(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          onPressed: () => _startAddNewWorkout(context),
          backgroundColor: Colors.teal,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
