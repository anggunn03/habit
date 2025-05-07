import 'package:flutter/material.dart';
import 'package:habit/page/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  Habit? habit;
  bool initialized = false;

  final _formkey = GlobalKey<FormState>();
  String title = '';
  String description = '';

  Future save() async {
    if (_formkey.currentState!.validate()) {
      final supabase = Supabase.instance.client;

      if (habit != null) {
        await supabase
        .from('habits')
        .update({
          'name': title,
          'description': description,
        })
        .eq('id', habit?.id ?? '');
        
        
      } else {
        await supabase.from('habits').insert({
          'name': title,
          'description': description,
        });
      }
    }  
  }  
  Future delete() async {
    final confirmed = await showDialog<bool>(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Habit'),
          content: const Text('Apakah kamu yakin ingin menghapus kebiasaan ini?'),
          actions: [
            TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: const Text('Batal'),
            ),
            TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      final supabase = Supabase.instance.client;
      await supabase.from('habits').delete().eq('id', habit?.id ?? '');

    }
  }

  @override
  Widget build(BuildContext context) {
    habit = ModalRoute.of(context)?.settings.arguments as Habit?;
    if (habit != null && !initialized) {
      setState(() {
        title = habit!.name;
        description = habit!.description ?? '';
        initialized = true;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${(habit != null) ? 'Edit' : 'Add'} Habit'),
        actions: [
          IconButton(icon: const Icon(Icons.delete), 
          onPressed: delete),
        ]
      ),
      body: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Habit Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a habit name';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              initialValue: description,
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
            ElevatedButton(onPressed: save, child: const Text('Save')),
          ],
        ) 
      ),
    );
  }
}