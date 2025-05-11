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
  String name= '';
  String description = '';

  Future save() async {
    if (_formkey.currentState!.validate()) {
      final supabase = Supabase.instance.client;
      String message = 'Berhasil menyimpan habit';
    
      if (habit != null) {
        await supabase
        .from('habitnows')
        .update({
          'name': name,
          'description': description,
        })
        .eq('id', habit?.id ?? '');
        message = 'Habit Berhasil diupdate';
      } else {
        await supabase.from('habitnows').insert({
          'name': name,
          'description': description,
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      Navigator.pop<String>(context, 'OK');
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
      await supabase.from('habitnows').delete().eq('id', habit?.id ?? '');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit berhasil dihapus')),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    habit = ModalRoute.of(context)?.settings.arguments as Habit?;
    if (habit != null && !initialized) {
      setState(() {
        name = habit!.name;
        description = habit!.description ?? '';
        });
        initialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${(habit != null) ? 'edit' : 'Tambahkan'} Habit'),
        actions:
        (habit != null) 
        ? [
          IconButton(icon: const Icon(Icons.delete), 
          onPressed: delete),
        ]
        : [],
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama Habit'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'masukkan nama habit';
                }
                return null;
              },
              initialValue: name,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Deskripsi Habit'),
              initialValue: description,
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
            ElevatedButton(onPressed: save, child: const Text('Simpan')),
          ],
        ) 
      ),
    );
  }
}