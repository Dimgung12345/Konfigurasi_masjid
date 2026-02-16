import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import '../../core/services/banner_service.dart';
import '../../core/models/client_baner.dart';
import '../widgets/UploadCard.dart';
import '../widgets/SaveButton.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({super.key});

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  final _service = clientBannerService;
  List<ClientBanner> _banners = [];
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    try {
      final data = await _service.getBanners();
      setState(() {
        _banners = data;
        _loading = false;
        _error = false;
      });
    } catch (e) {
      debugPrint("❌ Error load banners: $e");
      setState(() {
        _loading = false;
        _error = true;
      });
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Koneksi terputus, cek Internet Anda")),
      );
    }
  }

  Future<void> _pickAndUploadBanner({int? bannerId}) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = await MultipartFile.fromFile(picked.path);
      if (bannerId != null) {
        await _service.updateBanner(bannerId, file);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Slot ini belum tersedia, hubungi admin")),
        );
      }
      await _loadBanners();
    }
  }

  Future<void> _save() async {
    Navigator.pop(context, _banners);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kembali"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 'dashboard'); // balik ke dashboard
          },
        ),
      ),
        body: _error
            ? ListView.builder(
                itemCount: 3,
                itemBuilder: (_, __) => const SkeletonBannerCard(),
              ):
            _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: 5, // sesuai mockup: Banner 1, Banner 2, Banner 3
                      itemBuilder: (context, index) {
                        final bannerNumber = index + 1;
                        final b = index < _banners.length ? _banners[index] : null;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Banner $bannerNumber",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 12),
                              UploadCard(
                                imageUrl: b?.url,
                                onPickFile: () {
                                  if (b != null) {
                                    _pickAndUploadBanner(bannerId: b.id);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Slot ini belum tersedia, hubungi admin"),
                                      ),
                                    );
                                  }
                                },
                                height: 180,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SaveButton(onSave: _save),
                  ),
                ),
              ],
            ),
    );
  }
}