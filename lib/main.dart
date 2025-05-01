import 'package:flutter/material.dart';
import 'start_screen.dart'; // Import StartScreen
import 'login_page.dart';  // Import LoginPage
import 'sign_up_page.dart'; // Import SignUpPage

void main() {
  runApp(MyGameApp());
}

class MyGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Initial route set to LoginPage
      routes: {
        '/start': (context) => StartScreen(),  // Add the StartScreen as another route
        '/login': (context) => LoginPage(),    // Add the LoginPage route
        '/sign_up': (context) => SignUpPage(), // Add the SignUpPage route
      },
    );
  }
}
