import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future _fetchHabit() async {
  final supabase = Supabase.instance.client;

  final data = await supabase
      .from('myhabit')
      .select()
      .order('created_at', ascending: true);

      return data;
}

class Habit {
  final String id;
  final String name;
  final String? description;
  final bool done;

  const Habit({
    required this.id,
    required this.name,
    required this.description,
    this.done = false,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit( 
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        done: json['done'] as bool,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future futureHabit;

  @override
  void initState() {
    super.initState();
    futureHabit = _fetchHabit();
  }  

  Future <void> _updateHabitDone(String id, bool done) async {
    final supabase = Supabase.instance.client;
    await supabase
        .from('myhabit')
        . update({
          'done': done})
        .eq('id', id);
  }

  Future<void> _habitPage(BuildContext context, Object? arguments) async {
    final result = await Navigator.pushNamed(
      context,
      '/habit/page',
      arguments: arguments,
    );

    if (result == 'OK') {
      setState(() {
        futureHabit = _fetchHabit();
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
          future: futureHabit,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final habit = Habit.fromJson(snapshot.data[index]);
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        habit.done ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: habit.done ? Colors.green : null,
                      ),
                      title: Text(habit.name),
                      subtitle: Text(habit.description ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              habit.done ? Icons.check_box : Icons.check_box_outline_blank,
                              color: habit.done ? Colors.green : null,
                            ),
                            onPressed: () {
                              _updateHabitDone(habit.id, !habit.done);
                              setState(() {
                                futureHabit = _fetchHabit();
                              });
                            },
                          ),    
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _habitPage(context, habit);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirmed = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi'),
                                    content: const Text('Apakah anda yakin ingin menghapus kebiasaan ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (confirmed == true) {
                                final supabase = Supabase.instance.client;
                                await supabase
                                    .from('myhabit')
                                    .delete()
                                    .eq('id', habit.id);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Habit berhasil dihapus'),
                                  ),
                                );
                                setState(() {
                                  futureHabit = _fetchHabit();
                                });
                              }
                            }, 
                          ),
                        ],
                      ),
                    )
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}'); 
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