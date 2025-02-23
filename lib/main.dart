import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'settings.dart';

void main() {
  runApp(WomanSafetyApp());
}

class WomanSafetyApp extends StatelessWidget {
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
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
