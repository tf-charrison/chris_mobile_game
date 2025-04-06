import 'package:flutter/material.dart';
import 'obstacle.dart';

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
