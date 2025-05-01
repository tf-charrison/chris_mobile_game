import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http;

Future<bool> signUpUser(String username, String email, String password, String passwordConfirmation) async {
  // Define the URL for the register API on your Rails server
  final url = Uri.parse('http://10.0.2.2:3000/register'); // Update this URL if needed

  // Prepare the request body with username, email, password, and password_confirmation
  final body = json.encode({
    'user': {
      'username': username, // Add username
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    },
  });

  try {
    // Make the POST request to the backend to register the user
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    // Check the response
    if (response.statusCode == 201) {
      // If registration is successful, you can show a success message
      print('Sign-up successful');
      return true;
    } else {
      // Handle sign-up failure and show error messages
      print('Sign-up failed: ${json.decode(response.body)['errors']}');
      return false;
    }
  } catch (error) {
    print('Error during sign-up: $error');
    return false;
  }
}
