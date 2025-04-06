import 'package:flutter/material.dart';
import 'start_screen.dart'; // Import StartScreen

void main() {
  runApp(MyGameApp());
}

class MyGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(), // StartScreen is now the first screen
    );
  }
}
