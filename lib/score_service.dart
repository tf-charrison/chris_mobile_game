import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _secureStorage = FlutterSecureStorage();

Future<bool> submitScore(int score, String difficulty) async {
  final url = Uri.parse('http://10.0.2.2:3000/scores');

  // Get the token stored at login
  final token = await _secureStorage.read(key: 'jwt_token');

  if (token == null) {
    print('No token found. User not logged in.');
    return false;
  }

  final body = json.encode({
    'score': score,
    'difficulty': difficulty,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 👈 Include the JWT token here
      },
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Score submitted successfully!');
      return true;
    } else {
      print('Failed to submit score: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error submitting score: $e');
    return false;
  }
}
