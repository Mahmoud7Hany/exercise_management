// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

// مؤقت
class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;
  int _start = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _loadTimerState();
  }

  Future<void> _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _start = prefs.getInt('start_time') ?? 0;
      _isRunning = prefs.getBool('is_running') ?? false;
      if (_isRunning) {
        _startTimer();
      }
    });
  }

  Future<void> _saveTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('start_time', _start);
    prefs.setBool('is_running', _isRunning);
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) {
      return; // المؤقت قيد التشغيل بالفعل
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _start++;
      });
      _saveTimerState(); // حفظ الحالة في كل تحديث
    });
    setState(() {
      _isRunning = true;
    });
    _saveTimerState(); // حفظ الحالة عند بدء التشغيل
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isRunning = false;
    });
    _saveTimerState(); // حفظ الحالة عند الإيقاف
  }

  void _resetTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _start = 0;
      _isRunning = false;
    });
    _saveTimerState(); // حفظ الحالة عند إعادة التعيين
  }

  void _copyToClipboard() {
    final timeString =
        '${(_start / 60).floor()}:${(_start % 60).toString().padLeft(2, '0')}';
    Clipboard.setData(ClipboardData(text: timeString)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم نسخ الوقت: $timeString')),
      );
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _saveTimerState(); // حفظ الحالة عند إغلاق التطبيق
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'المؤقت',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${(_start / 60).floor()}:${(_start % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  _isRunning ? Icons.pause : Icons.play_arrow,
                  _isRunning ? 'أوقف' : 'ابدأ',
                  _isRunning ? _stopTimer : _startTimer,
                ),
                const SizedBox(width: 15),
                _buildButton(Icons.restart_alt, 'إعادة تعيين', _resetTimer),
                const SizedBox(width: 15),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.copy, size: 24),
                  label: const Text('نسخ'),
                  onPressed: _copyToClipboard,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(icon, size: 24),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
