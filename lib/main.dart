import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';

void main() {
  runApp(WomanSafetyApp());
}

class WomanSafetyApp extends StatelessWidget {
  const WomanSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Woman Safety App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomeScreen(),
        
      },
    );
  }
}
