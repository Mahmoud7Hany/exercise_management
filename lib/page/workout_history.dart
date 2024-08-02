// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// سجل التعديلات
class WorkoutHistory extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  final VoidCallback clearHistory;

  const WorkoutHistory(
      {super.key, required this.history, required this.clearHistory});

  @override
  _WorkoutHistoryState createState() => _WorkoutHistoryState();
}

class _WorkoutHistoryState extends State<WorkoutHistory> {
  String _formatTime(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    formattedTime = formattedTime.replaceAll('AM', 'ص').replaceAll('PM', 'م');
    return formattedTime;
  }

  String _formatDate(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'سجل التعديلات',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            onPressed: () {
              widget.clearHistory();
            },
          ),
        ],
      ),
      body: widget.history.isEmpty
          ? const Center(
              child: Text(
                'لا توجد تعديلات مسجلة بعد!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: widget.history.length,
              itemBuilder: (ctx, index) {
                final oldWorkout = widget.history[index]['old'];
                final newWorkout = widget.history[index]['new'];
                final timestamp = widget.history[index]['timestamp'];

                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تعديل في ${_formatDate(timestamp)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'الساعة: ${_formatTime(timestamp)}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'التمرين القديم:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text('الاسم: ${oldWorkout['name']}'),
                        Text('المدة: ${oldWorkout['duration']} دقيقة'),
                        Text('التكرارات: ${oldWorkout['repetitions']}'),
                        const SizedBox(height: 10),
                        const Text(
                          'التمرين الجديد:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text('الاسم: ${newWorkout['name']}'),
                        Text('المدة: ${newWorkout['duration']} دقيقة'),
                        Text('التكرارات: ${newWorkout['repetitions']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
