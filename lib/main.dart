import 'package:flutter/material.dart';

void main() {
  runApp(MyGameApp());
}

class MyGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double playerX = 100;
  double playerY = 100;

  void movePlayer(double dx, double dy) {
    setState(() {
      playerX += dx;
      playerY += dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        movePlayer(details.localPosition.dx - playerX, details.localPosition.dy - playerY);
      },
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: GamePainter(playerX, playerY),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final double playerX;
  final double playerY;

  GamePainter(this.playerX, this.playerY);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Draw player (simple circle)
    canvas.drawCircle(Offset(playerX, playerY), 20, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
