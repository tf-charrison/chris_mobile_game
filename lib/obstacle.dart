// obstacle.dart
import 'package:flutter/widgets.dart';

class Obstacle {
  Offset position;
  double size;
  double dx; // Horizontal speed
  double dy; // Vertical speed

  Obstacle(this.position, this.size, {this.dx = 0, this.dy = 0});

  // Move the obstacle and bounce off the edges
  void move(double screenWidth, double screenHeight) {
    // Update the position
    position = Offset(position.dx + dx, position.dy + dy);

    // Bounce off left and right boundaries
    if (position.dx <= 0 || position.dx >= screenWidth - size) {
      dx = -dx; // Reverse horizontal direction
    }

    // Bounce off top and bottom boundaries
    if (position.dy <= 0 || position.dy >= screenHeight - size) {
      dy = -dy; // Reverse vertical direction
    }
  }
}
