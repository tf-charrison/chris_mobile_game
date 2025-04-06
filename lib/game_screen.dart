// game_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'obstacle.dart'; // Import the Obstacle class
import 'game_painter.dart'; // Import the GamePainter

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
      Obstacle(Offset(200, 300), 20, dx: 2, dy: 2),  // Horizontal and vertical movement
      Obstacle(Offset(500, 400), 30, dx: -3, dy: 1),
      Obstacle(Offset(300, 600), 25, dx: 1.5, dy: -1.5),
    ];

    _ticker = createTicker((_) {
      if (!gameOver) {
        setState(() {
          for (var obstacle in obstacles) {
            // Pass screen width and height to handle boundary checks
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
