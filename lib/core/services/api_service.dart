import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<Map<String, String>> _headers() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> get(String endpoint) async {
    final base = 'http://10.2.131.30:4000';
    final headers = await _headers();
    final res = await http.get(Uri.parse('$base$endpoint'), headers: headers);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    throw Exception('Error ${res.statusCode}: ${res.body}');
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final base = 'http://10.2.131.30:4000';
    final headers = await _headers();
    final res = await http.post(
      Uri.parse('$base$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    throw Exception('Error ${res.statusCode}: ${res.body}');
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final base = 'http://10.2.131.30:4000';
    final headers = await _headers();
    final res = await http.put(
      Uri.parse('$base$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    throw Exception('Error ${res.statusCode}: ${res.body}');
  }
}