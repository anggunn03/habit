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
      String message;
    
      if (habit != null) {
        await supabase
            .from('myhabit')
            .update({
              'name': name,
              'description': description,
          })
            .eq('id', habit?.id ?? '');
        message = 'Berhasil mengubah kebiasaan';
      
      } else {
        await supabase.from('myhabit').insert({
          'name': name,
          'description': description,
        });
      
        message = 'Berhasil menambahkan kebiasaan';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      Navigator.pop<String>(context, 'OK');
      } 
  }  

  @override
  Widget build(BuildContext context) {
    habit = ModalRoute.of(context)!.settings.arguments as Habit?;
    if (habit != null && !initialized) {
      setState(() {
        name = habit?.name ?? '';
        description = habit!.description ?? '';
        });
        initialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${(habit != null) ? 'Edit' : 'Tambahkan'} Kebiasaan'),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama Kebiasaan'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan nama kebiasaan';
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
              decoration: const InputDecoration(labelText: 'Deskripsi Singkat'),
              initialValue: description,
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),

            const SizedBox(height : 20),
            ElevatedButton(
              onPressed: save,
              child: const Text('Simpan')),
          ],
        ) 
      ),
    );
  }
}