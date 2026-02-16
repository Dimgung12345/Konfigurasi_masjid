import 'package:dashboard_masjid/screen/pages/main_page.dart';
import 'package:flutter/material.dart';
import '../../core/models/master_client.dart';
import '../../core/services/master_client_service.dart';
import '../pages/edit_client_page.dart';
import '../widgets/dashboardCard.dart';
import '../pages/edit_banner_page.dart';
import '../pages/edit_hadist_page.dart';
// import '../pages/laporan_keuangan_page.dart'; // 👉 bikin FinancePage

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late MasterClientService _service;
  MasterClient? _client;
  bool _loading = true;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _service = MasterClientService();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // dari kiri
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _loadClient();
  }

  Future<void> _loadClient() async {
    try {
      final c = await _service.getClient();
      setState(() {
        _client = c;
        _loading = false;
      });
      // ✅ jalankan animasi masuk setelah data siap
      _controller.forward();
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _navigateToPage(Widget page) {
    // ✅ animasi keluar dashboard ke kanan
    _controller.reverse().then((_) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page))
          .then((_) {
        // ✅ saat kembali, dashboard animasi masuk lagi dari kiri
        _controller.reset();
        _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _client?.name != null
        ? "${_client!.name} Control Panel"
        : "Control Panel";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Dashboard",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),

                    // Konfigurasi Masjid
                    SettingItem(
                      color: const Color(0xFFFFC107),
                      icon: Icons.build,
                      title: "Konfigurasi Masjid",
                      onTap: () {
                        if (_client != null) {
                          _navigateToPage(EditMasterClientPage(client: _client!));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Data client belum siap")),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    SettingItem(
                      color: const Color(0xFF4CAF50),
                      icon: Icons.image,
                      title: "Konfigurasi Banner",
                      onTap: () => _navigateToPage(BannerPage()),
                    ),
                    const SizedBox(height: 12),
                    SettingItem(
                      color: const Color(0xFF2196F3),
                      icon: Icons.menu_book,
                      title: "Konfigurasi Hadist",
                      onTap: () => _navigateToPage(HadistPage()),
                    ),
                    const SizedBox(height: 12),
                    SettingItem(
                      color: const Color(0xFF9C27B0),
                      icon: Icons.account_balance,
                      title: "Laporan Keuangan",
                      onTap: () async {
                        try {
                          // langsung push ke page, biarkan interceptor handle 403
                          _navigateToPage(MainPage());
                        } catch (e) {
                          // fallback kalau ada error lain
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Fitur premium. Hubungi admin untuk mengaktifkan."),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}