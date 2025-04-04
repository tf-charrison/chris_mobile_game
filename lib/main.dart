import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // ✅ Needed for Ticker
import 'dart:async';

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

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameScreen()),
            );
          },
          child: Text('Start Game', style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

class Obstacle {
  Offset position;
  double speedX;
  double speedY;

  Obstacle(this.position, this.speedX, this.speedY);

  void move(double maxWidth, double maxHeight) {
    // Move in both X and Y directions
    position = Offset(position.dx + speedX, position.dy + speedY);

    // Bounce off edges of the screen
    if (position.dx <= 0 || position.dx >= maxWidth) {
      speedX = -speedX; // Reverse X direction
    }

    if (position.dy <= 0 || position.dy >= maxHeight) {
      speedY = -speedY; // Reverse Y direction
    }
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  double playerX = 100;
  double playerY = 100;
  bool gameOver = false;
  late Ticker _ticker;
  late List<Obstacle> obstacles;

  @override
  void initState() {
    super.initState();
    obstacles = [
      Obstacle(Offset(200, 300), 2, 2),  // speedX, speedY
      Obstacle(Offset(500, 400), -3, 1), // speedX, speedY
      Obstacle(Offset(300, 600), 1.5, -2), // speedX, speedY
    ];

    _ticker = createTicker((_) {
      if (!gameOver) {
        setState(() {
          for (var obstacle in obstacles) {
            obstacle.move(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
            if ((playerX - obstacle.position.dx).abs() < 40 &&
                (playerY - obstacle.position.dy).abs() < 40) {
              gameOver = true;
            }
          }
        });
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void movePlayer(double dx, double dy) {
    if (gameOver) return;

    double newPlayerX = playerX + dx;
    double newPlayerY = playerY + dy;

    for (var obstacle in obstacles) {
      if ((newPlayerX - obstacle.position.dx).abs() < 40 &&
          (newPlayerY - obstacle.position.dy).abs() < 40) {
        setState(() {
          gameOver = true;
        });
        return;
      }
    }

    setState(() {
      playerX = newPlayerX;
      playerY = newPlayerY;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gameOver) {
      return Scaffold(
        appBar: AppBar(title: Text('Game Over')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Restart'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            movePlayer(details.localPosition.dx - playerX, details.localPosition.dy - playerY);
          },
          child: CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: GamePainter(playerX, playerY, obstacles),
          ),
        ),
        buildControlButtons()
      ],
    );
  }

  Widget buildControlButtons() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height - 180),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => movePlayer(-10, 0),
              child: Text("Left"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () => movePlayer(10, 0),
              child: Text("Right"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () => movePlayer(0, -10),
              child: Text("Up"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () => movePlayer(0, 10),
              child: Text("Down"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class GamePainter extends CustomPainter {
  final double playerX;
  final double playerY;
  final List<Obstacle> obstacles;

  GamePainter(this.playerX, this.playerY, this.obstacles);

  @override
  void paint(Canvas canvas, Size size) {
    final playerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(playerX, playerY), 20, playerPaint);

    final obstaclePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    for (var obstacle in obstacles) {
      canvas.drawRect(
        Rect.fromCenter(center: obstacle.position, width: 40, height: 40),
        obstaclePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
