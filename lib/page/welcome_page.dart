import 'package:flutter/material.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat Datang di Aplikasi Habit Tracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height : 20),
            const Text(
              'Bangun kebiasaan baik, Raih hidup lebih baik.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height : 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home/page');
              },
              child: const Text('Mulai Sekarang'),
            ),
          ],
        )),
    );
  }
}
