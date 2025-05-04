import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final List<Map<String, String>> _habits = []; // Daftar kebiasaan

  void _addHabit() {
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();

    if (name.isNotEmpty) {
      setState(() {
        _habits.add({'name': name, 'description': desc});
      });
      _nameController.clear();
      _descController.clear();
      Navigator.pop(context); // Tutup dialog
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HABIT'),
      ),
      body: _habits.isEmpty
          ? const Center(
              child: Text(
                'Belum ada kebiasaan. Tambahkan kebiasaan baru!',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(habit['name'] ?? 'No Name'),
                    subtitle: Text(habit['description'] ?? 'No Description'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _habits.removeAt(index); // Hapus kebiasaan
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Tambah Kebiasaan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nama Kebiasaan'),
                ),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: _addHabit,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}