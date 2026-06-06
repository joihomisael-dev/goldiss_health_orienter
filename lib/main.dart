import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goldiss_health_orienter/screens/welcome_screen.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const GoldissHealthApp());
}

//Je me suis réveiller avec une doubleurs trés intense et soudaine sur Le testicules gauches, et la doubleurs s'accenture aux movement  telque marche et autres, etc
class GoldissHealthApp extends StatelessWidget {
  const GoldissHealthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goldiss Health Orienter',
      theme: ThemeData(
        primaryColor: const Color(0xFF14A896),
        scaffoldBackgroundColor: const Color(0xFFF5F7F9),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2332),
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
        ),
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
