import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit/page/habit_tracker_page.dart';

void main() async {
  await Supabase.initialize(url: '', anonKey: '');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/habit/tracker': (context) => const HabitTrackerPage(),
      },
    );
  }
}
