import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'https://srv1301-files.hstgr.io/966a0c25a024c892/api';

  Future<Map<String, dynamic>> register(
      String name,
      String email,
      String password,
      String passwordConfirmation,
      String address,
      String phone,
      String license) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'adresse': address,
        'telephone': phone,
        'permis': license,
      }),
    );

    if (response.statusCode == 201) {
      return {'success': true, 'data': json.decode(response.body)};
    } else {
      return {'success': false, 'errors': json.decode(response.body)};
    }
  }


  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      // Affichage pour le débogage
      print('Response Body: ${response.body}');
      print('Status Code: ${response.statusCode}');

      // Gestion des cas de succès
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      }

      // Gestion des cas spécifiques
      if (response.statusCode == 401) {
        return {'success': false, 'message': 'Invalid credentials'};
      }

      if (response.statusCode == 403) {
        return {'success': false, 'message': 'Access denied (403 Forbidden)'};
      }

      // Gestion des erreurs non prévues
      return {
        'success': false,
        'message': 'Unexpected error: ${response.statusCode}'
      };
    } catch (e) {
      // Gestion des exceptions (par exemple, problème réseau)
      print('Error: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }




}
