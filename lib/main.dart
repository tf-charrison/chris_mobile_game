import 'package:flutter/material.dart';
import 'start_screen.dart'; // Import StartScreen
import 'login_page.dart';  // Import LoginPage

void main() {
  runApp(MyGameApp());
}

class MyGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // You can change this to StartScreen() later if needed
      routes: {
        '/start': (context) => StartScreen(),  // Add the StartScreen as another route
      },
    );
  }
}
