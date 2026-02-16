import 'package:flutter/material.dart';
import '../../core/models/hadist.dart';
import '../../core/models/client_hadist.dart';
import '../../core/models/hadistdto.dart';
import '../../core/services/hadist_service.dart';
import '../widgets/hadistCard.dart';
import '../widgets/SaveButton.dart';

class HadistPage extends StatefulWidget {
  const HadistPage({super.key});

  @override
  State<HadistPage> createState() => _HadistPageState();
}

class _HadistPageState extends State<HadistPage> {
  final _service = HadistService();
  List<Map<String, dynamic>> _merged = [];
  bool _loading = true;
  bool _error = false;

  int _currentPage = 1;
  int _totalPages = 54; // misalnya fixed dulu, bisa dari API

  @override
  void initState() {
    super.initState();
    _loadHadists();
  }

  Future<void> _loadHadists({int page = 1}) async {
    try {
      final global = await _service.getGlobalHadists(page: page);
      final clientDTOs = await _service.getClientHadists(page: page);

      final merged = <Map<String, dynamic>>[];
      for (var h in global) {
        final dto = clientDTOs.firstWhere(
          (x) => x.id == h.id,
          orElse: () => HadistDTO(
            id: h.id,
            konten: h.konten,
            riwayat: h.riwayat,
            kitab: h.kitab,
            enabled: true,
          ),
        );

        final c = ClientHadist(
          id: 0,
          clientId: "",
          hadistId: dto.id,
          disabled: !dto.enabled,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        merged.add({"hadist": h, "client": c});
      }

      setState(() {
        _merged = merged;
        _loading = false;
        _error = false;
        _currentPage = page;
      });
    } catch (e) {
      debugPrint("❌ Error load hadist: $e");
      setState(() {
        _loading = false;
        _error = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Koneksi terputus, cek Internet Anda")),
      );
    }
  }

  Future<void> _toggleHadist(ClientHadist clientHadist, bool disabled) async {
    try {
      await _service.toggleHadist(clientHadist.hadistId, disabled);
      setState(() {
        final index = _merged.indexWhere(
          (x) => (x["client"] as ClientHadist).hadistId == clientHadist.hadistId,
        );
        if (index != -1) {
          _merged[index]["client"] = clientHadist.copyWith(disabled: disabled);
        }
      });
    } catch (e) {
      debugPrint("❌ Error toggle: $e");
    }
  }

  Future<void> _save() async {
    // meskipun toggle langsung nyimpan, tombol save bisa dipakai untuk keluar/commit
    Navigator.pop(context, _merged);
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
      body: Column(
        children: [
          // Segmen konfigurasi di bawah AppBar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: Text(
              "Konfigurasi Hadist",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
            ),
          ),

          // Konten utama
          Expanded(
            child: _error
            ? ListView.builder(
              itemCount: 5,
              itemBuilder: (_, __) => const SkeletonHadistCard(),
            ) : 
            ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _merged.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final h = _merged[index]["hadist"] as Hadist;
                final c = _merged[index]["client"] as ClientHadist;
                return HadistCard(
                  hadist: h,
                  clientHadist: c,
                  onToggle: _toggleHadist,
                );
              },
            ),
          ),

          // Indikator page
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Prev arrow
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _currentPage > 1
                      ? () => _loadHadists(page: _currentPage - 1)
                      : null,
                ),

                // Current ±1 (3 angka aktif)
                for (int i = _currentPage - 1; i <= _currentPage + 1; i++)
                  if (i >= 1 && i <= _totalPages)
                    TextButton(
                      onPressed: () => _loadHadists(page: i),
                      child: Text(
                        "$i",
                        style: TextStyle(
                          fontWeight: _currentPage == i ? FontWeight.bold : FontWeight.normal,
                          color: _currentPage == i ? Colors.orange : Colors.black,
                        ),
                      ),
                    ),

                // Satu indikator "..." sebagai search page
                TextButton(
                  onPressed: () async {
                    final page = await showDialog<int>(
                      context: context,
                      builder: (ctx) {
                        final controller = TextEditingController();
                        return AlertDialog(
                          title: const Text("Lompat ke halaman"),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: "Masukkan nomor halaman"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                final val = int.tryParse(controller.text);
                                Navigator.pop(ctx, val);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                    if (page != null && page >= 1 && page <= _totalPages) {
                      _loadHadists(page: page);
                    }
                  },
                  child: const Text("..."),
                ),

                // Next arrow
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _currentPage < _totalPages
                      ? () => _loadHadists(page: _currentPage + 1)
                      : null,
                ),
              ],
            ),
          ),
          // Save button
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