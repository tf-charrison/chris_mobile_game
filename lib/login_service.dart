import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http;

Future<bool> loginUser(String email, String password) async {
  // Define the URL for the login API on your Rails server
  final url = Uri.parse('http://10.0.2.2:3000/login'); // Update this URL if needed

  // Prepare the request body
  final body = json.encode({
    'email': email,
    'password': password,
  });

  try {
    // Make the POST request to the backend
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    // Check the response
    if (response.statusCode == 200) {
      // If login is successful, you can extract the token and store it if needed
      final responseData = json.decode(response.body);
      final token = responseData['token'];

      // Store the token (use SharedPreferences or another method)
      print("Login successful, token: $token");
      return true;
    } else {
      // Handle login failure
      print('Login failed: ${json.decode(response.body)['message']}');
      return false;
    }
  } catch (error) {
    print('Error during login: $error');
    return false;
  }
}
