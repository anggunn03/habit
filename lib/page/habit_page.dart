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
        backgroundColor: Colors.blue[50],
        centerTitle: true,
        title: Text('${(habit != null) ? 'Edit' : 'Tambahkan'} Kebiasaan',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //label rata kiri
            children: [
              const Text(
                'Nama Kebiasaan',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),

            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width : 1),
                  ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width : 1),
                ),  
                fillColor: Colors.white,
                filled: true,
              ),
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
            const SizedBox(height : 20),
            const Text(
              'Deskripsi Singkat',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width : 1),
                  ),
                
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width : 1),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              initialValue: description,
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),

            const SizedBox(height : 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 82, 243),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
                ),
                
                onPressed: save,
                child: const Text('Simpan')),
            )
            ],
          ) 
        ),
      )
    );
  }
}