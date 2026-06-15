import 'package:flutter/material.dart'; // untuk membuat aplikasi flutter
import 'package:rest_api_demo/pages/home_page.dart'; // code di ambil dari folder rest_api_demo => pages => home_page.dart
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rest api flutter', // judul app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 153, 255),
        ),
      ), 
      home: const HomePage(), // Mengarah ke kelas di home_page.dart
    ); // MaterialApp
  }
}