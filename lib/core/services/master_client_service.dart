import 'package:dio/dio.dart';
import 'api_service.dart';
import '../models/master_client.dart';

class MasterClientService {
  final Dio _dio = ApiService.instance.client;

  /// Ambil konfigurasi masjid milik tenant (DKM)
  Future<MasterClient> getClient() async {
    final response = await _dio.get("/tenant/client");
    return MasterClient.fromJson(response.data);
  }

  /// Update konfigurasi masjid milik tenant (DKM)
  /// Kirim field teks + file upload (background, sound alert, banner)
    Future<void> updateClient(
      MasterClient client, {
      MultipartFile? logo,
      MultipartFile? soundAlert,
      MultipartFile? background,
    }) async {
      final formData = FormData.fromMap({
        "name": client.name,
        "location": client.location,
        "timezone": client.timezone,
        "config_title": client.configTitle,
        "running_text": client.runningText,
        "enable_hadis": client.enableHadis,
        "enable_hari_besar": client.enableHariBesar,
        "enable_kalender": client.enableKalender,
        if (logo != null) "logo": logo,
        if (soundAlert != null) "config_sound_alert": soundAlert,
        if (background != null) "config_background": background,
      });

      await _dio.put("/tenant/client", data: formData);
    }
}

final masterClientService = MasterClientService(); // 👉 instance siap pakai