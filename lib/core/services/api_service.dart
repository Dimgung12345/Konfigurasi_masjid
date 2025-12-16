import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService._internal()
      : _dio = Dio(BaseOptions(
          baseUrl: "http://10.2.22.23:8080", // 👉 URL cuma sekali di sini
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: "jwt_token");
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
    ));
  }

  static final ApiService instance = ApiService._internal(); // 👉 singleton

  Dio get client => _dio;

  Future<Response> get(String endpoint) async => await _dio.get(endpoint);
  Future<Response> post(String endpoint, Map<String, dynamic> data) async =>
      await _dio.post(endpoint, data: data);
  Future<Response> put(String endpoint, Map<String, dynamic> data) async =>
      await _dio.put(endpoint, data: data);
  Future<Response> delete(String endpoint) async => await _dio.delete(endpoint);
}