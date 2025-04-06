import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: SimpleGame()));
}

class SimpleGame extends FlameGame {
  late Rect character;

  @override
  Future<void> onLoad() async {
    // Character's starting position and size
    character = Rect.fromLTWH(100, 100, 50, 50);
  }

  @override
  void update(double dt) {
    // Example movement logic for the character (could be touched or dragged)
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.blue;
    canvas.drawRect(character, paint);
  }

  @override
  void onTapDown(TapDownDetails details) {
    // Move character to the tap location
    character = Rect.fromCenter(center: details.localPosition, width: 50, height: 50);
  }
}
