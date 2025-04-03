import 'package:flutter/material.dart';

void main() {
  runApp(MyGameApp());
}

class MyGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),  // StartScreen is now the first screen
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
            // Navigate to the game screen when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameScreen()),
            );
          },
          child: Text('Start Game', style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            backgroundColor: Colors.green,  // Background color of the button
            foregroundColor: Colors.white, // Text color
          ),
        ),
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

  // List of obstacles represented as (x, y) positions
  List<Offset> obstacles = [
    Offset(200, 300), // Obstacle 1
    Offset(500, 400), // Obstacle 2
    Offset(300, 600), // Obstacle 3
  ];

  bool gameOver = false;

  void movePlayer(double dx, double dy) {
    setState(() {
      double newPlayerX = playerX + dx;
      double newPlayerY = playerY + dy;

      // Collision detection with obstacles
      for (var obstacle in obstacles) {
        if ((newPlayerX - obstacle.dx).abs() < 40 && (newPlayerY - obstacle.dy).abs() < 40) {
          // If the player collides with an obstacle, stop the movement and end the game
          gameOver = true;
          return;
        }
      }

      // Update the player's position if no collision
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
              // Navigate back to start screen
              Navigator.pop(context);
            },
            child: Text('Restart'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              backgroundColor: Colors.red,  // Button background color
              foregroundColor: Colors.white, // Text color
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
        Positioned(
          bottom: 50,
          left: 50,
          child: ElevatedButton(
            onPressed: () {
              movePlayer(-10, 0); // Move left
            },
            child: Text("Left"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: Colors.blue,  // Button background color
              foregroundColor: Colors.white, // Text color
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 50,
          child: ElevatedButton(
            onPressed: () {
              movePlayer(10, 0); // Move right
            },
            child: Text("Right"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: Colors.blue,  // Button background color
              foregroundColor: Colors.white, // Text color
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: 50,
          child: ElevatedButton(
            onPressed: () {
              movePlayer(0, -10); // Move up
            },
            child: Text("Up"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: Colors.blue,  // Button background color
              foregroundColor: Colors.white, // Text color
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: 50,
          child: ElevatedButton(
            onPressed: () {
              movePlayer(0, 10); // Move down
            },
            child: Text("Down"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: Colors.blue,  // Button background color
              foregroundColor: Colors.white, // Text color
            ),
          ),
        ),
      ],
    );
  }
}

class GamePainter extends CustomPainter {
  final double playerX;
  final double playerY;
  final List<Offset> obstacles;

  GamePainter(this.playerX, this.playerY, this.obstacles);

  @override
  void paint(Canvas canvas, Size size) {
    final playerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Draw player (simple circle)
    canvas.drawCircle(Offset(playerX, playerY), 20, playerPaint);

    final obstaclePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Draw obstacles (simple squares)
    for (var obstacle in obstacles) {
      canvas.drawRect(Rect.fromCenter(center: obstacle, width: 40, height: 40), obstaclePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
