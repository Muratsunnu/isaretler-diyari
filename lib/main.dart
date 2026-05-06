import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const IsaretlerDiyariApp());
}

class IsaretlerDiyariApp extends StatelessWidget {
  const IsaretlerDiyariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İşaretler Diyarı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
