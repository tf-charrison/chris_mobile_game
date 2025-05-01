import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _secureStorage = FlutterSecureStorage();

Future<bool> loginUser(String email, String password) async {
  final url = Uri.parse('http://10.0.2.2:3000/login');
  final body = json.encode({
    'email': email,
    'password': password,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];

      // 🔐 Store the token securely
      await _secureStorage.write(key: 'jwt_token', value: token);

      print("Login successful, token stored securely.");
      return true;
    } else {
      print('Login failed: ${json.decode(response.body)['message']}');
      return false;
    }
  } catch (error) {
    print('Error during login: $error');
    return false;
  }
}
