import 'package:dio/dio.dart';
import '../models/hadist.dart';
// import '../models/client_hadist.dart';
import '../models/hadistdto.dart'; // 👉 tambahin model DTO baru
import 'api_service.dart';
import 'package:flutter/material.dart';

class HadistService {
  final Dio _dio = ApiService.instance.client;

  /// Ambil hadist global dengan pagination
  Future<List<Hadist>> getGlobalHadists({int page = 1, int limit = 10}) async {
    final response = await _dio.get(
      "/tenant/hadist",
      queryParameters: {
        "limit": limit,
        "offset": (page - 1) * limit,
      },
    );
    debugPrint("📦 Raw global hadists JSON page $page: ${response.data}");
    final data = response.data as List;
    return data.map((json) => Hadist.fromJson(json)).toList();
  }

  /// Ambil hadist DTO (gabungan global + status enabled)
  Future<List<HadistDTO>> getClientHadists({int page = 1, int limit = 10}) async {
    final response = await _dio.get(
      "/tenant/hadists",
      queryParameters: {
        "limit": limit,
        "offset": (page - 1) * limit,
      },
    );
    debugPrint("📦 Raw client hadists JSON page $page: ${response.data}");
    final data = response.data as List;
    return data.map((json) => HadistDTO.fromJson(json)).toList();
  }

  /// Toggle enable/disable hadist tenant
  Future<void> toggleHadist(int hadistId, bool disabled) async {
    if (disabled) {
      await _dio.put("/tenant/hadists/$hadistId/disable");
    } else {
      await _dio.put("/tenant/hadists/$hadistId/enable");
    }
  }
}

final hadistService = HadistService();