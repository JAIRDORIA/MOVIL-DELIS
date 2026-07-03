import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String base = 'https://snackflow-api.onrender.com';

  static Future<dynamic> get(String endpoint) async {
    final res = await http.get(
      Uri.parse('$base$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    }

    throw Exception('Error ${res.statusCode}: ${res.body}');
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$base$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    }

    throw Exception('Error ${res.statusCode}: ${res.body}');
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$base$endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    }

    throw Exception('Error ${res.statusCode}: ${res.body}');
  }
}