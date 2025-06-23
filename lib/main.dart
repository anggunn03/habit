import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit/page/welcome_page.dart';
import 'package:habit/page/home_page.dart';
import 'package:habit/page/habit_page.dart'; // mengimpor halaman yang akan digunakan dalam aplikasi
Future<void> main() async { // fungsi utama untuk menjalankan aplikasi
  await Supabase.initialize( // dengan inisialisasi Supabase untuk menghubungkan aplikasi dengan database
    url: 'https://zyjcucjmurzhnxdrzcbt.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp5amN1Y2ptdXJ6aG54ZHJ6Y2J0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUyMTk5NTIsImV4cCI6MjA2MDc5NTk1Mn0.s-NdEi8KuQ3wmFXFElSL69yCeQFGFF2goSKGb5ty4EU');
  runApp(const MainApp()); // menjalankan aplikasi dengan widget MainApp
}

class MainApp extends StatelessWidget { // widget utama aplikasi
  // menggunakan StatelessWidget karena tidak ada perubahan state pada widget ini
  const MainApp({super.key}); // konstruktor untuk widget MainApp 

  @override 
  Widget build(BuildContext context) { // build untuk membangun widget yang akan ditampilkan
    // menggunakan MaterialApp untuk membuat aplikasi 
    return MaterialApp(
      debugShowCheckedModeBanner: false, // menghilangkan banner debug di pojok kanan atas
      theme: ThemeData( // mengatur tema aplikasi
        scaffoldBackgroundColor: Colors.blue[50], // dengan menggunakan warna biru muda sebagai latar belakang
      )
      ,
      initialRoute: '/welcome', // menentukan rute awal aplikasi
      routes: { //dengan rute yang akan digunakan dalam aplikasi
        '/welcome': (context) => const WelcomePage(), 
        '/home/page': (context) => const HomePage(),
        '/habit/page': (context) => const HabitPage(),

      },
    );
  }
}