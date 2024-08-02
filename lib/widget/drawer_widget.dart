import 'package:exercise_management/page/timer_page.dart';
import 'package:flutter/material.dart';

// هذه صفحة القائمة الجانبية التي في الصفحة الرئيسية
class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2a9d8f), // اللون الأخضر الداكن
                  Color(0xFFb56576), // اللون الوردي الداكن
                  Color(0xFF76d7c4), // اللون الأخضر الفاتح
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                'إدارة التمارين',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.timer, color: Colors.green),
            title: const Text('مؤقت'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimerPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
