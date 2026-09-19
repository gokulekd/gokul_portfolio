import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'firebase_portfolio_service.dart';

/// Day 11 decision: the contact form writes to both Formspree (instant email
/// notification) and Firestore (populates the admin "Visitor Submissions"
/// inbox, which previously had nothing writing to it). The Firestore write
/// is best-effort — a failure there never blocks the Formspree result the
/// UI actually surfaces to the visitor.
///
/// After a successful Firestore write, the Supabase Edge Function
/// `notify-new-lead` is pinged so the admin gets an FCM push. It only receives
/// the submission ID and re-reads the lead from Firestore itself, so nothing
/// the visitor typed is trusted as notification content. Also best-effort.
class ContactService {
  ContactService(this._firebaseService);

  final FirebasePortfolioService _firebaseService;

  static const _formspreeUrl = 'https://formspree.io/f/xpqbrwpw';
  static const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

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
      final submissionId = await _firebaseService.createSubmission(
        name: name,
        email: email,
        message: message,
      );
      if (submissionId != null) unawaited(_notifyNewLead(submissionId));
    } catch (_) {
      // Non-fatal — the visitor-facing result is Formspree's, not this.
    }

    return response.statusCode == 200;
  }

  Future<void> _notifyNewLead(String submissionId) async {
    if (_supabaseUrl.isEmpty || _supabaseAnonKey.isEmpty) return;
    try {
      await http
          .post(
            Uri.parse('$_supabaseUrl/functions/v1/notify-new-lead'),
            headers: {
              'Content-Type': 'application/json',
              'apikey': _supabaseAnonKey,
              'Authorization': 'Bearer $_supabaseAnonKey',
            },
            body: jsonEncode({'submissionId': submissionId}),
          )
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      // Push is a nice-to-have; Formspree email + the in-app alert remain.
    }
  }
}
