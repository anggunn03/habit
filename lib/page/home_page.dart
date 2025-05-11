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
    return switch (json) {
    {
        'id': String id,
        'name': String name,
        'description': String? description,
    } =>
      Habit(
        id: id,
        name: name,
        description: description,
      ),
    _ => throw Exception('Invalid Habit JSON'),
    };

  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future futureHabits;

  @override
  void initState() {
    super.initState();
    futureHabits = _fetchHabits();
  }  

  Future<void> _habitPage(BuildContext context, Object? arguments) async {
    final result = await Navigator.pushNamed(
      context,
      '/habit/page',
      arguments: arguments,
    );

    if (result == 'OK') {
      setState(() {
        futureHabits = _fetchHabits();
      });
    }
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('HABIT')),
      body: Center(
        child: FutureBuilder(
          future: futureHabits,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final habit = Habit.fromJson(snapshot.data[index]);
                  return ListTile(
                    title: Text(habit.name),
                    subtitle: Text(habit.description ?? ''),
                    onTap: () {
                      _habitPage(context, habit);
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Error loading habits');
            } 
            return const CircularProgressIndicator();
          }, 
          ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _habitPage(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}