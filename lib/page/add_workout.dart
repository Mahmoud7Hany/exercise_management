// ignore_for_file: library_private_types_in_public_api

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
  int? _duration;
  int? _repetitions;

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _name = widget.workout!['name'];
      _duration = widget.workout!['duration'];
      _repetitions = widget.workout!['repetitions'];
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop({
        'name': _name,
        'duration': _duration ?? 0,
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
              TextFormField(
                initialValue:
                    widget.workout != null ? _duration.toString() : '',
                decoration: const InputDecoration(
                  labelText: 'المدة (بالدقائق)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'الرجاء إدخال المدة';
                  }
                  return null;
                },
                onSaved: (value) {
                  _duration = int.tryParse(value!);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue:
                    widget.workout != null ? _repetitions.toString() : '',
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
