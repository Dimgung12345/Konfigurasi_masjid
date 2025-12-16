import 'package:flutter/material.dart';
import '../../core/models/master_client.dart';
import '../../core/services/master_client_service.dart';
import '../edit/edit_client_page.dart';
import '../widgets/dashboardCard.dart';
import '../edit/edit_banner_page.dart';
import '../edit/edit_hadist_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late MasterClientService _service;
  MasterClient? _client;
  bool _loading = true;
  

  @override
  void initState() {
    super.initState();
    _service = MasterClientService();
    _loadClient();
  }

  Future<void> _loadClient() async {
    try {
      final c = await _service.getClient();
      debugPrint("✅ Client loaded: ${c.name}, id=${c.id}");
      setState(() {
        _client = c;
        _loading = false;
      });
    } catch (e, stack) {
      debugPrint("❌ Error load client: $e");
      debugPrint(stack.toString());
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal load client: $e")),
      );
    }
  }

  @override 
    Widget build(BuildContext context) {
      final title = _client?.name != null
          ? "${_client!.name} Control Panel"
          : "Control Panel"; // 👉 fallback aman

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // ✅ arrow default dihilangkan
          title: Text(title),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Dashboard",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),

                      // Konfigurasi Masjid
                      SettingItem(
                        color: const Color(0xFFFFC107),
                        icon: Icons.build,
                        title: "Konfigurasi Masjid",
                        onTap: () {
                          if (_client != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditMasterClientPage(client: _client!),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Data client belum siap")),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 12),

                      // Banner
                      SettingItem(
                        color: const Color(0xFF4CAF50),
                        icon: Icons.image,
                        title: "Konfigurasi Banner",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BannerPage(), // 👉 bikin BannerPage
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // Hadist
                      SettingItem(
                        color: const Color(0xFF2196F3),
                        icon: Icons.menu_book,
                        title: "Konfigurasi Hadist",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HadistPage(), // 👉 bikin HadistPage
                            ),
                          );
                        },  
                      ),
                    ],
                  )
              ),
      );
    }
}