import 'package:http/http.dart' as http;

class ContactService {
  static const _formspreeUrl = 'https://formspree.io/f/xpqbrwpw';

  Future<bool> submitContactForm({
    required String name,
    required String email,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse(_formspreeUrl),
      headers: {'Accept': 'application/json'},
      body: {'name': name, 'email': email, 'message': message},
    );
    return response.statusCode == 200;
  }
}
