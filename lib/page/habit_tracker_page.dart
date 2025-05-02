import 'package:flutter/material.dart';

class HabitTrackerPage extends StatelessWidget {
  const HabitTrackerPage({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Habit Tracker Page")),
      body: Center(child: const Text("Habit Tracker Page"),),
    );
  }
}