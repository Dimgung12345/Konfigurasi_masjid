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

  int _currentPage = 1;
  int _totalPages = 5; // misalnya fixed dulu, bisa dari API

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
        _currentPage = page;
      });
    } catch (e) {
      debugPrint("❌ Error load hadist: $e");
      setState(() => _loading = false);
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
            child: ListView.separated(
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
              children: List.generate(_totalPages, (i) {
                final page = i + 1;
                return GestureDetector(
                  onTap: () => _loadHadists(page: page),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == page
                          ? Colors.orange
                          : Colors.grey.shade400,
                    ),
                  ),
                );
              }),
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