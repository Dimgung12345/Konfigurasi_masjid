import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // cache in-memory
  final Map<String, _CacheEntry> _cache = {};

  ApiService._internal()
      : _dio = Dio(BaseOptions(
          baseUrl: "",
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

  // GET dengan caching
  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters,
      Duration ttl = const Duration(minutes: 5),
      bool forceRefresh = false}) async {
    final cacheKey = "$endpoint?${queryParameters?.toString() ?? ''}";

    // cek cache
    if (!forceRefresh && _cache.containsKey(cacheKey)) {
      final entry = _cache[cacheKey]!;
      if (DateTime.now().isBefore(entry.expiry)) {
        return Response(
          requestOptions: RequestOptions(path: endpoint),
          data: entry.data,
          statusCode: 200,
        );
      } else {
        _cache.remove(cacheKey); // expired
      }
    }

    // fetch dari server
    final res = await _dio.get(endpoint, queryParameters: queryParameters);
    _cache[cacheKey] = _CacheEntry(res.data, DateTime.now().add(ttl));
    return res;
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async =>
      await _dio.post(endpoint, data: data);

  Future<Response> put(String endpoint, Map<String, dynamic> data) async =>
      await _dio.put(endpoint, data: data);

  Future<Response> delete(String endpoint) async =>
      await _dio.delete(endpoint);

  // invalidate cache untuk endpoint tertentu
  void invalidate(String endpoint) {
    _cache.removeWhere((key, _) => key.startsWith(endpoint));
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiry;
  _CacheEntry(this.data, this.expiry);
}