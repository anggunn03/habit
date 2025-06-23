import 'package:flutter/material.dart';
import 'package:habit/page/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HabitPage extends StatefulWidget { //halaman untuk menambahkan atau mengubah kebiasaan
  //menggunakan StatefulWidget karena akan ada perubahan state ketika mengisi form
  const HabitPage({super.key}); //menampilkan halaman ini

  @override //menampilkan state dari halaman ini
  State<HabitPage> createState() => _HabitPageState();//menampilkan state dari halaman ini
}

class _HabitPageState extends State<HabitPage> { //state dari halaman HabitPage
  Habit? habit; 
  //jika null, berarti akan menambahkan kebiasaan baru, jika tidak null berarti mengubah kebiasaan yang sudah ada
  bool initialized = false; //untuk mengecek apakah sudah diinisialisasi atau belum

  final _formkey = GlobalKey<FormState>(); //menentukan key untuk form ini agar dapat diakses di dalam fungsi save
  //menggunakan GlobalKey untuk mengakses state dari form ini
  String name= ''; //variabel untuk menyimpan nama kebiasaan
  //menggunakan string karena nama kebiasaan berupa teks
  String description = ''; //variabel untuk menyimpan nama dan deskripsi kebiasaan

  Future save() async { //fungsi untuk menyimpan data kebiasaan
    if (_formkey.currentState!.validate()) { //memeriksa apakah form valid
      final supabase = Supabase.instance.client;//mengambil instance dari Supabase client
      String message; //variabel untuk menyimpan pesan yang akan ditampilkan
    
      if (habit != null) { //jika habit tidak null, berarti akan mengubah kebiasaan yang sudah ada
        await supabase
            .from('myhabit') //mengambil data dari tabel myhabit
            .update({//mengupdate data kebiasaan yakni ada nama dan deskripsi
              'name': name,
              'description': description,
          })
            .eq('id', habit?.id ?? ''); //menggunakan eq untuk menentukan id kebiasaan yang akan diubah
        //menggunakan id dari kebiasaan yang akan diubah
        message = 'Berhasil mengubah kebiasaan'; //pesan yang akan ditampilkan jika berhasil mengubah kebiasaan
      
      } else { 
        await supabase.from('myhabit').insert({ //jika habit null, berarti akan menambahkan kebiasaan baru
          'name': name,
          'description': description,
        });
      
        message = 'Berhasil menambahkan kebiasaan';//pesan yang akan ditampilkan jika berhasil menambahkan kebiasaan
      }
      if (!mounted) return; //memeriksa apakah widget masih terpasang di dalam tree
      ScaffoldMessenger.of(context).showSnackBar( //menampilkan snackbar
        SnackBar(content: Text(message)), //menampilkan pesan yang sesuai
      );
      Navigator.pop<String>(context, 'OK'); //kembali ke halaman sebelumnya dengan mengirimkan nilai 'OK'
      } 
  }  

  @override 
  Widget build(BuildContext context) { 
    habit = ModalRoute.of(context)!.settings.arguments as Habit?; //mengambil data habit dari argumen yg dikirimkan dari halaman sebelumnya
    //jika tidak ada argumen yang dikirimkan, maka habit akan bernilai null
    if (habit != null && !initialized) { //jika habit tidak null dan belum diinisialisasi
        //artinya halaman ini digunakan untuk mengubah kebiasaan yang sudah ada
        //jadi kita akan mengisi form dengan data kebiasaan yang sudah ada
      setState(() { 
        name = habit?.name ?? '';
        description = habit!.description ?? ''; 
        }); //mengisi form dengan data kebiasaan yang sudah ada
      //menggunakan setState untuk memperbarui state halaman ini
        initialized = true; //menandakan bahwa halaman ini sudah diinisialisasi
    }

    return Scaffold( //untuk membuat struktur dasar halaman
      appBar: AppBar( //menampilkan judul halaman
        backgroundColor: Colors.blue[50],
        centerTitle: true,
        title: Text('${(habit != null) ? 'Edit' : 'Tambahkan'} Kebiasaan', //jika habit tidak null, maka akan menampilkan 'Edit Kebiasaan', jika null maka akan menampilkan 'Tambahkan Kebiasaan'
          style: const TextStyle( 
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,// menampilkan teks dengan ukuran 24 dan tebal
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), //ikon untuk kembali ke halaman sebelumnya
          onPressed: () { //tombol untuk kembali ke halaman sebelumnya
            //jika tombol ini ditekan, maka akan kembali ke halaman sebelumnya
            Navigator.pop(context); //menutup halaman ini dan kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Form( //form untuk menambahkan atau mengubah kebiasaan
        //menggunakan Form widget untuk membuat form yang dapat divalidasi
        key: _formkey, //menentukan key untuk form ini agar dapat diakses di dalam fungsi save
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //label rata kiri
            children: [ //widget untuk menampilkan form
            const SizedBox(height : 20), //jarak antara appbar dan form
              const Text(
                'Nama Kebiasaan',
                style: TextStyle(fontSize: 16, color: Colors.black), //label untuk nama kebiasaan
              ),

            TextFormField( //widget untuk input nama kebiasaan
              decoration: const InputDecoration( //decoration untuk input nama kebiasaan
                border: OutlineInputBorder(), //border untuk input nama kebiasaan
                //menggunakan OutlineInputBorder untuk memberikan border pada input
                enabledBorder: OutlineInputBorder( //border ketika input tidak fokus
                  //menggunakan OutlineInputBorder untuk memberikan border pada input
                  borderSide: BorderSide(color: Colors.grey, width : 1), //warna border ketika input tidak fokus
                  //warna border ketika input tidak fokus
                  ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width : 1), //warna border ketika input fokus
                  //warna border ketika input fokus
                ),  
                fillColor: Colors.white,
                filled: true, //menggunakan fillColor untuk memberikan warna latar belakang pada input
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan nama kebiasaan'; //validasi untuk memastikan nama kebiasaan tidak kosong
                }
                  return null; //jika validasi berhasil, maka akan mengembalikan null
              },
              initialValue: name,
              onChanged: (value) {
                setState(() {
                  name = value; //mengupdate nilai name ketika input berubah
                });
              },
            ),
            const SizedBox(height : 20), //jarak antara input nama kebiasaan dan deskripsi kebiasaan
            const Text(
              'Deskripsi Singkat',
              style: TextStyle(fontSize: 16, color: Colors.black), //label untuk deskripsi kebiasaan
            ),
            
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(), //border untuk input deskripsi kebiasaan
                //menggunakan OutlineInputBorder untuk memberikan border pada input
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width : 1), //warna border ketika input tidak fokus
                  ),
                
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width : 1), //warna border ketika input fokus
                ),
                fillColor: Colors.white, //warna latar belakang input deskripsi kebiasaan
                //menggunakan fillColor untuk memberikan warna latar belakang pada input
                filled: true, 
              ),
              initialValue: description, //mengisi input deskripsi kebiasaan dengan nilai deskripsi yang sudah ada
              //jika habit tidak null, maka akan mengisi input deskripsi kebiasaan dengan nilai deskripsi yang sudah ada
              onChanged: (value) {  //mengupdate nilai deskripsi ketika input berubah
                setState(() { 
                  description = value;  //mengupdate nilai deskripsi ketika input berubah
                });
              },
            ),

            const SizedBox(height : 24), //jarak antara input deskripsi kebiasaan dan tombol simpan
            Center(  //tombol simpan berada di tengah
              child: ElevatedButton( 
                style: ElevatedButton.styleFrom( //tombol simpan
                  //menggunakan ElevatedButton untuk membuat tombol simpan
                  backgroundColor: const Color.fromARGB(255, 33, 82, 243), //warna latar belakang tombol simpan
                  //menggunakan backgroundColor untuk memberikan warna latar belakang pada tombol simpan
                  foregroundColor: Colors.white, //warna teks tombol simpan
                  shape: const StadiumBorder(),   //agar tombol simpan berbentuk bulat
                  //menggunakan StadiumBorder untuk memberikan bentuk bulat pada tombol simpan
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16) //padding untuk tombol simpan
                  //menggunakan padding untuk memberikan jarak antara teks dan border tombol simpan
                ),
                
                onPressed: save, //fungsi yang akan dipanggil ketika tombol simpan ditekan
                child: const Text('Simpan')),  //menampilkan tombol simpan
            )
            ],
          ) 
        ),
      )
    );
  }
}