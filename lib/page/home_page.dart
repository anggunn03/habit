import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future _fetchHabits() async {
  final supabase = Supabase.instance.client;

  final data = await supabase
      .from('habits')
      .select()
      .order('name');
      return data;
}

class Habit {
  final String id;
  final String name;
  final String? description;

  const Habit({
    required this.id,
    required this.name,
    this.description,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> futureHabits;



  @override
  void initState() {
    super.initState();
  }  

  Future<void> _navigateToEdit(BuildContext context, Map<String, dynamic>? habit) async {
    final result = await Navigator.pushNamed(
      context,
      '/habit/edit',
      arguments: habit,
    );

    if (result == 'OK') {
      setState(() {
        
      });
    }
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HABIT'),
      )
    );
  }
}