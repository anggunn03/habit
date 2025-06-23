import 'package:flutter/material.dart'; 


class WelcomePage extends StatelessWidget { //membuat halaman selamat datang
  //menggunakan StatelessWidget karena halaman ini tidak akan berubah
  const WelcomePage({super.key}); 

  @override 
  Widget build(BuildContext context) { // build untuk membangun widget yang akan ditampilkan
    //menggunakan Scaffold untuk membuat struktur dasar halaman
    return Scaffold( 
      body: Center( //menggunakan Center untuk menempatkan widget di tengah layar
        child:Column( //menggunakan Column untuk menampilkan widget secara vertikal
          mainAxisAlignment: MainAxisAlignment.center, //menggunakan mainAxisAlignment untuk menempatkan widget di tengah secara vertikal
          children: [ //menggunakan children untuk menampilkan widget yang akan ditampilkan
            const Text(
              'Selamat Datang di Aplikasi', //judul aplikasi
              textAlign: TextAlign.center, //judul ditengah
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), //menggunakan TextStyle untuk mengatur gaya teks
            ),
            const Text(
              'Habit Tracker', //judul aplikasi
              textAlign: TextAlign.center, //judul ditengah
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height : 20), //jarak antara judul dan deskripsi
            const Text(
              'Bangun kebiasaan baik, Raih hidup lebih baik.',
              textAlign: TextAlign.center,//menempatkan teks di tengah
              style: TextStyle(fontSize: 16), 
            ),
            const SizedBox(height : 40), //jarak antara deskripsi dan tombol
            //menggunakan ElevatedButton untuk membuat tombol yang dapat ditekan
            ElevatedButton(
              style: ElevatedButton.styleFrom(  //menggunakan styleFrom untuk mengatur gaya tombol
                backgroundColor: const Color.fromARGB(255, 33, 82, 243),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder( //menggunakan RoundedRectangleBorder untuk memberikan bentuk bulat pada tombol
                  borderRadius: BorderRadius.circular(30), //menggunakan BorderRadius.circular untuk memberikan radius pada sudut tombol
                ),
                padding: const EdgeInsets.symmetric(vertical: 16), //menggunakan padding untuk memberikan jarak antara teks dan border tombol
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/home/page');  //menggunakan Navigator untuk berpindah ke halaman home ketika tombol ditekan
              },
              child: const Padding(  //menggunakan Padding untuk memberikan jarak antara teks dan border tombol
                padding: EdgeInsets.symmetric(horizontal: 24), //menggunakan EdgeInsets.symmetric untuk memberikan jarak horizontal
                child: Text('Mulai Sekarang'), //teks yang ditampilkan pada tombol
              )
            ),
          ],
        )),
    );
  }
}
