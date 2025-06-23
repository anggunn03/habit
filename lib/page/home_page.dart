import 'package:flutter/material.dart'; // mengimpor paket flutter material untuk membuat antarmuka pengguna
import 'package:supabase_flutter/supabase_flutter.dart'; // mengimpor paket supabase_flutter untuk berinteraksi dengan Supabase

Future _fetchHabit() async { 
  final supabase = Supabase.instance.client; // menginialisasi supabase client

  final data = await supabase // mengambil data dari tabel 'myhabit'
      .from('myhabit')
      .select() // mengambil semua data
      .order('created_at', ascending: true); // mengurutkan data berdasarkan kolom 'created_at' dari yg lama ke yg baru, jd kebiasaan yg dibuat lebih dulu akan muncul di atas

      return data; //mengembalikan data yang diambil dari supabase
}

class Habit { // Model Habit untuk merepresentasikan data kebiasaan
  // id, name, description, dan done adalah atribut dari Habit
  final String id;
  final String name;
  final String? description; // deskripsi bisa null, jadi pakai tipe data nullable String
  bool done; // tidak pakai final agar status kebiasaan bisa diubah

  Habit({ // Constructor Habit untuk menginisialisasi atribut
    required this.id, // id adalah String yang wajib diisi
    required this.name, // name adalah String yang wajib diisi
    required this.description, // description adalah String yang bisa null
    this.done = false, // done adalah boolean yang defaultnya false, artinya kebiasaan belum selesai
  });

  factory Habit.fromJson(Map<String, dynamic> json) { // Factory constructor untuk membuat objek Habit dari Map JSON
    return Habit( // menginisialisasi atribut Habit dari Map JSON
        id: json['id'] as String, // id diambil dari json dengan tipe String
        name: json['name'] as String, // name diambil dari json dengan tipe String
        description: json['description'] as String?, // description diambil dari json dengan tipe String nullable
        done: json['done'] as bool, // done diambil dari json dengan tipe boolean 
    );
  }
}

class HomePage extends StatefulWidget { // Halaman HomePage untuk menampilkan daftar kebiasaan
  const HomePage({super.key}); //halaman ini akan menampilkan daftar kebiasaan yang sudah dibuat

  @override // membuat state untuk HomePage
  State<HomePage> createState() => _HomePageState(); // mengembalikan instance dari _HomePageState 
}

class _HomePageState extends State<HomePage> { // State untuk HomePage
  // State ini akan mengelola data dan tampilan dari HomePage
  late Future futureHabit; // menyimpan data kebiasaan yang diambil dari Supabase

  @override // inisialisasi state ketika halaman pertama kali dibuat
  void initState() { // inisialisasi futureHabit dengan memanggil fungsi _fetchHabit
    super.initState(); // memanggil initState dari superclass
    // untuk memastikan state diinisialisasi dengan benar
    futureHabit = _fetchHabit(); // memanggil fungsi _fetchHabit untuk mengambil data kebiasaan dari Supabase
  }  

  Future <void> _updateHabitDone(String id, bool done) async { // fungsi untuk mengupdate status done dari kebiasaan
    // String yang merepresentasikan id dari kebiasaan yang akan diupdate
    final supabase = Supabase.instance.client; // menginisialisasi supabase client
    await supabase // mengupdate data pada tabel 'myhabit'
        .from('myhabit')
        . update({ 
          'done': done}) // mengupdate kolom 'done' dengan nilai boolean yang diberikan
        .eq('id', id); // mencari data berdasarkan id yang diberikan
  }

  Future<void> _habitPage(BuildContext context, Object? arguments) async { // membuka halaman HabitPage untuk menambah atau mengedit kebiasaan
    // jika arguments tidak null, berarti kita akan mengedit kebiasaan yang sudah ada
    // jika arguments null, berarti kita akan menambah kebiasaan baru
    final result = await Navigator.pushNamed( // mengarahkan ke halaman HabitPage
      context,
      '/habit/page',
      arguments: arguments, // mengirimkan arguments ke halaman HabitPage
    ); 

    if (result == 'OK') { // jika hasil dari halaman HabitPage adalah 'OK', berarti ada perubahan pada data kebiasaan
      // maka kita perlu memperbarui daftar kebiasaan yang ditampilkan di HomePage
      setState(() { 
        futureHabit = _fetchHabit(); // memanggil ulang fungsi _fetchHabit untuk mengambil data kebiasaan terbaru dari Supabase
      });
    }
  }

@override // build method untuk membangun tampilan HomePage
  Widget build(BuildContext context) {  // membangun tampilan
    return Scaffold( // widget dasar untuk halaman
      appBar: AppBar( // menampilkan judul halaman
        backgroundColor: Colors.blue[50], // warna latar belakang AppBar
        centerTitle: true, // judul berada di tengah
        title: const Text('Habit Tracker', // judul halaman
          style: TextStyle( // gaya teks judul
            color: Colors.black, // warna teks judul
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center( // menampilkan daftar kebiasaan di tengah halaman
        child: FutureBuilder( // menunggu data kebiasaan yang diambil dari Supabase
          initialData: const [], // data awal adalah list kosong
          future: futureHabit, // future yang akan diambil datanya
          builder: (context, snapshot) { // builder untuk membangun tampilan berdasarkan status future
            if (snapshot.hasData) { // jika future sudah selesai dan memiliki data
              return ListView.builder( // membangun daftar kebiasaan menggunakan ListView.builder
                itemCount: snapshot.data.length, // jumlah item dalam daftar sesuai dengan jumlah data yang diambil
                padding: const EdgeInsets.all(8.0), // padding untuk daftar dengan jarak 8.0
                itemBuilder: (context, index) { // membangun setiap item dalam daftar
                  final habit = Habit.fromJson(snapshot.data[index]); // mengonversi data dari Map JSON ke objek Habit
                  return Card( // kemudian menampilkan setiap kebiasaan dalam Card
                    color: Colors.white, // dengan warna latar belakang putih
                    child: ListTile( // menampilkan setiap kebiasaan dalam ListTile
                      leading: IconButton( // ikon tampil di sebelah kiri
                        icon: Icon(
                          habit.done ? Icons.check_circle : Icons.radio_button_unchecked,// jika habit.done true, tampilkan ikon check_circle, jika false tampilkan radio_button_unchecked
                          color: habit.done ? Colors.green : null,// hijau jika done, tidak berwarna jika belum done
                        ),
                        onPressed: () {// ketika ikon ditekan, ubah status done dari kebiasaan
                          _updateHabitDone(habit.id, !habit.done);// memanggil fungsi _updateHabitDone untuk mengupdate id habit dan status done
                          setState(() { // memanggil setState untuk memperbarui tampilan
                            snapshot.data[index]['done'] = !habit.done; //mengubah status done pd data yg ditampilkan agar ikon berubah tanpa perlu menunggu fetch ulang
                          });
                        }
                      ),
                    
                      title: Text(habit.name),// menampilkan nama kebiasaan sebagai judul
                      subtitle: Text(habit.description ?? ''),// menampilkan deskripsi kebiasaan sebagai subtitle, jika deskripsi null maka tampilkan string kosong
                      trailing: Row( // menampilkan ikon edit dan delete di sebelah kanan
                        mainAxisSize: MainAxisSize.min, // ukuran baris diatur ke minimum agar tidak mengambil ruang lebih
                        children: [ // menampilkan ikon edit dan delete
                          // ketika ikon edit ditekan, buka halaman HabitPage untuk mengedit kebiasaan
                          IconButton( 
                            icon: const Icon(Icons.edit, color: Colors.black), //icon edit berwarna hitam
                            tooltip: 'Edit Kebiasaan', // tooltip yang muncul ketika ikon edit ditekan
                            onPressed: () { // ketika ikon edit ditekan
                              _habitPage(context, habit); // memanggil fungsi _habitPage untuk membuka halaman HabitPage dengan mengirimkan objek habit sebagai argumen
                            },
                          ),
                          
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Hapus Kebiasaan', 
                            onPressed: () async { // ketika ikon delete ditekan, tampilkan dialog konfirmasi untuk menghapus kebiasaan
                              final confirmed = await showDialog( // menampilkan dialog konfirmasi
                                context: context, //
                                builder: (context) { // builder untuk dialog konfirmasi
                                  return AlertDialog( // dialog konfirmasi
                                    backgroundColor: Colors.white, // warna latar belakang dialog
                                    title: const Text('Konfirmasi'), // judul dialog
                                    content: const Text('Apakah anda yakin ingin menghapus kebiasaan ini?'), // konten dialog
                                    actions: [ // aksi yang ditampilkan di bawah dialog
                                      // tombol batal dan hapus
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false), // ketika tombol batal ditekan, tutup dialog dan kembalikan nilai false
                                        child: const Text('Batal', // tombol batal
                                          style: TextStyle(color: Colors.black), // warna teks tombol batal 
                                        ),
                                      ),
                                      TextButton( 
                                        onPressed: () => Navigator.of(context).pop(true), 
                                        child: const Text('Hapus', 
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ),
                                    ],
                                  );
                                }
                              );
                              if (confirmed == true) { // jika pengguna mengonfirmasi untuk menghapus kebiasaan
                                // maka hapus kebiasaan dari database Supabase
                                final supabase = Supabase.instance.client; 
                                await supabase // menghapus data dari tabel 'myhabit'
                                    .from('myhabit')
                                    .delete() // menghapus data
                                    .eq('id', habit.id); // mencari data berdasarkan id yang diberikan
                                // setelah berhasil menghapus, tampilkan snackbar sebagai notifikasi
                                if (!context.mounted) return; // periksa apakah context masih valid
                                ScaffoldMessenger.of(context).showSnackBar( // menampilkan snackbar
                                  const SnackBar(
                                    content: Text('Kebiasaan berhasil dihapus'),
                                  ),
                                );
                                setState(() {
                                  futureHabit = _fetchHabit(); // memperbarui daftar kebiasaan dengan memanggil ulang fungsi _fetchHabit
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) { // jika terjadi kesalahan saat mengambil data
              // tampilkan pesan kesalahan
              return Center(child: Text('Terjadi kesalahan: ${snapshot.error}')); // menampilkan pesan kesalahan yang terjadi
            }
            return const Center(child: CircularProgressIndicator()); // jika masih memuat data, tampilkan indikator pemuatan
          },
        ),
      ),
      floatingActionButton: FloatingActionButton( // tombol aksi mengapung untuk menambah kebiasaan baru
        backgroundColor: const Color.fromARGB(255, 33, 82, 243),
        foregroundColor: Colors.white, // warna latar belakang dan teks tombol
        onPressed: () {
          _habitPage(context, null); // ketika tombol ditekan, buka halaman HabitPage untuk menambah kebiasaan baru
        },
        child: const Icon(Icons.add), // ikon tambah pada tombol
      ),
    );
  }
}