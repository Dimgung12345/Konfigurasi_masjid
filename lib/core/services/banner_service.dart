import 'package:dio/dio.dart';
import '../models/client_baner.dart';
import 'api_service.dart';
import 'package:flutter/material.dart';

class ClientBannerService {
  final Dio _dio = ApiService.instance.client;

  /// Ambil semua banner tenant
  Future<List<ClientBanner>> getBanners() async {
    final response = await _dio.get("/tenant/banners");
    debugPrint("📦 Raw banners JSON: ${response.data}");
    final data = response.data as List;
    return data.map((json) => ClientBanner.fromJson(json)).toList();
  }

  /// Update banner tenant (misalnya ganti file)
  Future<void> updateBanner(int bannerId, MultipartFile file) async {
    final formData = FormData.fromMap({
      "banner": file,
    });
    await _dio.put("/tenant/banners/$bannerId", data: formData);
  }

  /// Hapus banner tenant
  Future<void> deleteBanner(int bannerId) async {
    await _dio.delete("/tenant/banners/$bannerId");
  }
}

final clientBannerService = ClientBannerService();