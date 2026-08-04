import 'package:http/http.dart' as http;

import 'firebase_portfolio_service.dart';

/// Day 11 decision: the contact form writes to both Formspree (instant email
/// notification) and Firestore (populates the admin "Visitor Submissions"
/// inbox, which previously had nothing writing to it). The Firestore write
/// is best-effort — a failure there never blocks the Formspree result the
/// UI actually surfaces to the visitor.
class ContactService {
  ContactService(this._firebaseService);

  final FirebasePortfolioService _firebaseService;

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

    try {
      await _firebaseService.createSubmission(
        name: name,
        email: email,
        message: message,
      );
    } catch (_) {
      // Non-fatal — the visitor-facing result is Formspree's, not this.
    }

    return response.statusCode == 200;
  }
}
