import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'dart:math';
import 'obstacle.dart';
import 'game_painter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'score_service.dart'; // update with actual path

enum Difficulty {
  easy,
  medium,
  hard,
}

class GameScreen extends StatefulWidget {
  final Difficulty difficulty;

  GameScreen({required this.difficulty});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  double playerX = 100;
  double playerY = 100;
  bool gameOver = false;
  int lives = 3;
  bool isInGracePeriod = false;
  late Ticker _ticker;
  late List<Obstacle> obstacles;
  int score = 0;
  late double scoreMultiplier;
  late Timer scoreTimer;

  @override
  void initState() {
    super.initState();

    int obstacleCount;
    double speedFactor;

    switch (widget.difficulty) {
      case Difficulty.easy:
        obstacleCount = 2;
        speedFactor = 1.0;
        scoreMultiplier = 1.0;
        break;
      case Difficulty.medium:
        obstacleCount = 4;
        speedFactor = 1.5;
        scoreMultiplier = 2.0;
        break;
      case Difficulty.hard:
        obstacleCount = 6;
        speedFactor = 2.0;
        scoreMultiplier = 3.0;
        break;
    }

    final random = Random();
    obstacles = List.generate(obstacleCount, (index) {
      final position = Offset(
        100.0 + random.nextDouble() * 300,
        100.0 + random.nextDouble() * 500,
      );
      final dx = (random.nextDouble() * 2 + 1) * speedFactor * (random.nextBool() ? 1 : -1);
      final dy = (random.nextDouble() * 2 + 1) * speedFactor * (random.nextBool() ? 1 : -1);
      return Obstacle(position, (20 + random.nextInt(15)).toDouble(), dx: dx, dy: dy);
    });

    _ticker = createTicker((_) {
      if (!gameOver) {
        setState(() {
          for (var obstacle in obstacles) {
            obstacle.move(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
            if ((playerX - obstacle.position.dx).abs() < 40 &&
                (playerY - obstacle.position.dy).abs() < 40) {
              if (!isInGracePeriod) {
                handleCollision();
              }
            }
          }
        });
      }
    });

    _ticker.start();

    scoreTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (!gameOver && !isInGracePeriod) {
        setState(() {
          score += (10 * scoreMultiplier).toInt();
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    scoreTimer.cancel();
    super.dispose();
  }

  void handleCollision() {
    setState(() {
      if (lives > 1) {
        lives--;
        isInGracePeriod = true;
      } else {
        gameOver = true;
        saveScore();  // Call the API to save the score when game is over.
      }
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        isInGracePeriod = false;
      });
    });
  }

  void movePlayer(double dx, double dy) {
    if (gameOver || isInGracePeriod) return;

    double newPlayerX = playerX + dx;
    double newPlayerY = playerY + dy;

    for (var obstacle in obstacles) {
      if ((newPlayerX - obstacle.position.dx).abs() < 40 &&
          (newPlayerY - obstacle.position.dy).abs() < 40) {
        handleCollision();
        return;
      }
    }

    setState(() {
      playerX = newPlayerX;
      playerY = newPlayerY;
    });
  }

  // Function to save the score to the API
  Future<void> saveScore() async {
    bool success = await submitScore(score, widget.difficulty.name);

    if (success) {
      print("Score saved successfully!");
    } else {
      print("Failed to save score.");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gameOver) {
      return Scaffold(
        appBar: AppBar(title: Text('Game Over')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Score: $score',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
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
            ],
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
        buildControlButtons(),
        buildLivesDisplay(),
        buildScoreDisplay(),
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

  Widget buildLivesDisplay() {
    return Positioned(
      top: 40,
      right: 20,
      child: Text(
        'Lives: $lives',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget buildScoreDisplay() {
    return Positioned(
      top: 40,
      left: 20,
      child: Text(
        'Score: $score',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
