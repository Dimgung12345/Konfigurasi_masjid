import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService.instance; // 👉 reuse singleton
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> login(String username, String password, String device) async {
    final response = await _api.post("/login", {
      "username": username,
      "password": password,
      "device": device,
    });

    if (response.statusCode == 200) {
      final token = response.data["token"];

      // 👉 simpan token ke storage
      await _storage.write(key: "jwt_token", value: token);

      return token;
    } else {
      throw Exception(response.data["error"] ?? "Login gagal");
    }
  }

  Map<String, dynamic> decodeToken(String token) {
    return JwtDecoder.decode(token);
  }

  Future<String?> getSavedToken() async {
    return await _storage.read(key: "jwt_token");
  }

  Future<void> logout() async {
    await _storage.delete(key: "jwt_token");
  }
}

final authService = AuthService(); // 👉 instance siap pakai