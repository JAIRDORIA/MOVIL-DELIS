import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}class Ruta {
  // URL base del backend en producción (Render)
  static String baseUrl = "https://snackflow-api.onrender.com";
}