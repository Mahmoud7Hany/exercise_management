// ignore_for_file: library_private_types_in_public_api

import 'package:exercise_management/page/timer_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // لاستخدام jsonEncode و jsonDecode

// اضافه التمارين الرياضيه الصفحه الرئيسيه
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> workouts = [];
  int workoutCount = 0; // عدد التمارين
  double totalDuration = 0; // إجمالي الوقت بالدقائق (يقبل الرقم العشري)
  int totalCalories = 0; // إجمالي السعرات الحرارية

  List<String> workoutCategories = ['القوة', 'الكارديو', 'التحمل', 'أخرى'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadWorkouts(); // تحميل التمارين عند بداية التطبيق
  }

  void _loadWorkouts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedWorkouts = prefs.getString('workouts');
    if (savedWorkouts != null) {
      setState(() {
        workouts = List<Map<String, dynamic>>.from(jsonDecode(savedWorkouts));
        workoutCount = workouts.length;
        totalDuration =
            workouts.fold(0.0, (sum, item) => sum + item['duration']);
        totalCalories = workouts.fold(
            0, (sum, item) => sum + (item['calories'] as num).toInt());
      });
    }
  }

  void _saveWorkouts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('workouts', jsonEncode(workouts));
  }

  void _deleteWorkout(int index) {
    setState(() {
      // تحديث القيم بعد حذف التمرين
      totalDuration -= workouts[index]['duration'];
      totalCalories -= (workouts[index]['calories'] as num).toInt();
      workouts.removeAt(index);
      workoutCount = workouts.length;
    });
    _saveWorkouts(); // حفظ القائمة الجديدة بعد الحذف
  }

  void _editWorkout(int index) {
    final workout = workouts[index];
    String workoutName = workout['name'];
    String workoutCategory = workout['category'];
    String workoutDuration = workout['duration'].toString();
    String workoutReps = workout['reps'].toString();
    bool isCustomCategory = workoutCategory == 'أخرى';

    _showAddWorkoutDialog(
      initialName: workoutName,
      initialCategory: workoutCategory,
      initialDuration: workoutDuration,
      initialReps: workoutReps,
      isEdit: true,
      index: index,
      isCustomCategory: isCustomCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'إدارة التمارين الرياضية',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history,
              color: Colors.black,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TimerPage()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('إحصائيات اليوم',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                    'التمارين', workoutCount.toString(), Icons.fitness_center),
                _buildStatCard('السعرات', totalCalories.toString(),
                    Icons.local_fire_department),
                _buildStatCard('المدة',
                    '${totalDuration.toStringAsFixed(1)} دقيقة', Icons.timer),
              ],
            ),
            const SizedBox(height: 20),
            const Text('أحدث التمارين',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final workout = workouts[index];
                  return _buildWorkoutCard(
                    workout['name'] ?? 'تمرين',
                    workout['category'] ?? 'القوة',
                    '${workout['duration']} دقيقة - ${workout['reps']} تكرار',
                    Icons.directions_run,
                    index, // تمرير الفهرس لاستخدامه في الحذف والتعديل
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          _showAddWorkoutDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.blueAccent),
          const SizedBox(height: 10),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(
      String title, String category, String details, IconData icon, int index) {
    final workout = workouts[index];
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent, size: 40),
        title: Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$category - $details',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 5),
            Text('تاريخ الإضافة: ${workout['date']}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () {
                _editWorkout(index); // استدعاء دالة التعديل
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteWorkout(index); // استدعاء دالة الحذف
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddWorkoutDialog({
    String initialName = '',
    String initialCategory = 'القوة',
    String initialDuration = '',
    String initialReps = '',
    bool isEdit = false,
    int index = -1,
    bool isCustomCategory = false,
  }) {
    String workoutName = initialName;
    String workoutCategory = initialCategory;
    String workoutDuration = initialDuration;
    String workoutReps = initialReps;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'تعديل التمرين' : 'إضافة تمرين جديد'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: workoutName,
                  decoration: const InputDecoration(hintText: 'اسم التمرين'),
                  onChanged: (value) {
                    workoutName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم التمرين';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: workoutCategories.contains(workoutCategory)
                      ? workoutCategory
                      : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      workoutCategory = newValue!;
                      isCustomCategory = workoutCategory == 'أخرى';
                    });
                  },
                  items: workoutCategories
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration:
                      const InputDecoration(hintText: 'اختر نوع التمرين'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى اختيار نوع التمرين';
                    }
                    return null;
                  },
                ),
                if (isCustomCategory)
                  TextFormField(
                    initialValue: workoutCategory,
                    decoration:
                        const InputDecoration(hintText: 'أدخل نوع التمرين'),
                    onChanged: (value) {
                      workoutCategory = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال نوع التمرين';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: workoutDuration,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(hintText: 'مدة التمرين (بالدقائق)'),
                  onChanged: (value) {
                    workoutDuration = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال مدة التمرين';
                    }
                    if (double.tryParse(value) == null) {
                      return 'يرجى إدخال رقم صالح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: workoutReps,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'عدد التكرارات'),
                  onChanged: (value) {
                    workoutReps = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال عدد التكرارات';
                    }
                    if (int.tryParse(value) == null) {
                      return 'يرجى إدخال رقم صالح';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    double duration = double.parse(workoutDuration);
                    int reps = int.parse(workoutReps);
                    int calories =
                        _calculateCalories(workoutCategory, duration);
                    String formattedDate = _getCurrentFormattedDate();

                    if (isEdit && index != -1) {
                      totalDuration -= workouts[index]['duration'];
                      totalCalories -=
                          (workouts[index]['calories'] as num).toInt();
                      workouts[index] = {
                        'name': workoutName,
                        'category': workoutCategory,
                        'duration': duration,
                        'reps': reps,
                        'calories': calories,
                        'date': formattedDate
                      };
                    } else {
                      workouts.add({
                        'name': workoutName,
                        'category': workoutCategory,
                        'duration': duration,
                        'reps': reps,
                        'calories': calories,
                        'date': formattedDate
                      });
                    }

                    workoutCount = workouts.length;
                    totalDuration += duration;
                    totalCalories += calories;
                  });
                  _saveWorkouts();
                  Navigator.of(context).pop();
                }
              },
              child: Text(isEdit ? 'حفظ التعديل' : 'إضافة'),
            ),
          ],
        );
      },
    );
  }

  int _calculateCalories(String category, double duration) {
    // دالة لحساب السعرات الحرارية بناءً على نوع التمرين والمدة
    if (category == 'القوة') {
      return (duration * 8).round(); // مثال
    } else if (category == 'الكارديو') {
      return (duration * 10).round();
    } else {
      return (duration * 5).round(); // مثال لأنواع أخرى
    }
  }

  String _getCurrentFormattedDate() {
    DateTime now = DateTime.now();
    int hour =
        now.hour % 12 == 0 ? 12 : now.hour % 12; // تحويل الساعة إلى صيغة 12
    String period = now.hour >= 12 ? 'م' : 'ص'; // تحديد AM أو PM
    return "${now.day}/${now.month}/${now.year} - $hour:${now.minute} $period";
  }
}
