import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit/page/welcome_page.dart';
import 'package:habit/page/home_page.dart';
import 'package:habit/page/habit_page.dart'; 
Future<void> main() async { 
  await Supabase.initialize( 
    url: 'https://zyjcucjmurzhnxdrzcbt.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp5amN1Y2ptdXJ6aG54ZHJ6Y2J0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUyMTk5NTIsImV4cCI6MjA2MDc5NTk1Mn0.s-NdEi8KuQ3wmFXFElSL69yCeQFGFF2goSKGb5ty4EU');
  runApp(const MainApp()); 
}

class MainApp extends StatelessWidget { 
  const MainApp({super.key}); 

  @override 
  Widget build(BuildContext context) { 
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      theme: ThemeData( 
        scaffoldBackgroundColor: Colors.blue[50], 
      )
      ,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomePage(), 
        '/home/page': (context) => const HomePage(),
        '/habit/page': (context) => const HabitPage(),

      },
    );
  }
}