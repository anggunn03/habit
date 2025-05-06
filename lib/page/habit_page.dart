import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  List<dynamic> habit = [];
  bool initialized = false;

  final _formkey = GlobalKey<FormState>();
  String title = '';
  String description = '';

  Future save() async {
    if (_formkey.currentState!.validate()) {
      final supabase = Supabase.instance.client;

      if (title.isNotEmpty && description.isNotEmpty) {
        await supabase
        .from('habits')
        .select()
        .eq('name', title)
        .order('name');
        
      } else {
        await supabase.from('habits').update({
          'name': title,
          'description': description,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HABIT'),
      ),
    );
  }
}