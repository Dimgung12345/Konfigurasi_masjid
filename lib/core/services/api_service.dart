import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService._internal()
      : _dio = Dio(BaseOptions(
          baseUrl: "http://192.168.1.3:8080",
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
      onResponse: (response, handler) {
        if (response.statusCode == 403 &&
            response.requestOptions.path.startsWith("/tenant/finance")) {
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              error: "Finance feature not enabled",
              type: DioExceptionType.badResponse,
            ),
          );
        }
        return handler.next(response);
      },
    ));
  }

  static final ApiService instance = ApiService._internal();

  Dio get client => _dio;

  // GET tanpa cache
  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(endpoint, queryParameters: queryParameters);
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async =>
      await _dio.post(endpoint, data: data);

  Future<Response> put(String endpoint, Map<String, dynamic> data) async =>
      await _dio.put(endpoint, data: data);

  Future<Response> delete(String endpoint) async =>
      await _dio.delete(endpoint);
}