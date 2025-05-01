import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'leaderboard_screen.dart'; // Make sure this import is correct

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Difficulty', style: TextStyle(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 30),
            difficultyButton(context, Difficulty.easy, 'Easy'),
            difficultyButton(context, Difficulty.medium, 'Medium'),
            difficultyButton(context, Difficulty.hard, 'Hard'),
            const SizedBox(height: 20), // Add spacing between difficulty and leaderboard button
            leaderboardButton(context), // Leaderboard button
          ],
        ),
      ),
    );
  }

  // Difficulty selection buttons
  Widget difficultyButton(BuildContext context, Difficulty difficulty, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GameScreen(difficulty: difficulty),
            ),
          );
        },
        child: Text(label, style: TextStyle(fontSize: 20)),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  // Leaderboard button
  Widget leaderboardButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LeaderboardScreen(), // Navigate to leaderboard screen
            ),
          );
        },
        child: Text('Leaderboard', style: TextStyle(fontSize: 20)),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          backgroundColor: Colors.orange, // You can choose a different color if you like
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
