import 'package:flutter/material.dart';

// إضافة تمرين
class AddWorkout extends StatefulWidget {
  final Map<String, dynamic>? workout;

  const AddWorkout({super.key, this.workout});

  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int? _hours;
  int? _minutes;
  int? _seconds;
  int? _repetitions;

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _name = widget.workout!['name'];
      final totalSeconds = widget.workout!['duration'] ?? 0;
      _hours = totalSeconds ~/ 3600;
      _minutes = (totalSeconds % 3600) ~/ 60;
      _seconds = totalSeconds % 60;
      _repetitions = widget.workout!['repetitions'];
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final durationInSeconds =
          (_hours ?? 0) * 3600 + (_minutes ?? 0) * 60 + (_seconds ?? 0);
      Navigator.of(context).pop({
        'name': _name,
        'duration': durationInSeconds,
        'repetitions': _repetitions ?? 0,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: widget.workout == null
            ? const Text(
                'إضافة تمرين',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            : const Text(
                'تعديل تمرين',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'اسم التمرين',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'الرجاء إدخال اسم التمرين';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _hours?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'الساعات',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء إدخال الساعات';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _hours = int.tryParse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      initialValue: _minutes?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'الدقائق',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء إدخال الدقائق';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _minutes = int.tryParse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      initialValue: _seconds?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'الثواني',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء إدخال الثواني';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _seconds = int.tryParse(value!);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _repetitions?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'عدد التكرارات',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'الرجاء إدخال عدد التكرارات';
                  }
                  return null;
                },
                onSaved: (value) {
                  _repetitions = int.tryParse(value!);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: widget.workout == null
                    ? const Text('إضافة تمرين')
                    : const Text('تعديل تمرين'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
