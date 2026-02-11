import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart'; // ✅ untuk audio

import '../../core/models/master_client.dart';
import '../../core/services/master_client_service.dart';
import '../widgets/UploadCard.dart';
import '../widgets/FormCard.dart';
import '../widgets/SaveButton.dart';

class EditMasterClientPage extends StatefulWidget {
  final MasterClient? client;

  const EditMasterClientPage({super.key, this.client});

  @override
  State<EditMasterClientPage> createState() => _EditMasterClientPageState();
}

class _EditMasterClientPageState extends State<EditMasterClientPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  late TextEditingController nameCtrl;
  late TextEditingController locationCtrl;
  late TextEditingController timezoneCtrl;
  late TextEditingController titleCtrl;
  late TextEditingController runningTextCtrl;

  MasterClient? _client;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.client != null) {
      _client = widget.client;
      _initControllers(_client!);
      _loading = false;
    }
    _fetchClient();
  }

  void _initControllers(MasterClient client) {
    nameCtrl = TextEditingController(text: client.name);
    locationCtrl = TextEditingController(text: client.location);
    timezoneCtrl = TextEditingController(text: client.timezone);
    titleCtrl = TextEditingController(text: client.configTitle);
    runningTextCtrl = TextEditingController(text: client.runningText ?? "");
  }

  Future<void> _fetchClient() async {
    try {
      final service = MasterClientService();
      final c = await service.getClient();
      setState(() {
        _client = c;
        _initControllers(c);
        _loading = false;
      });
    } catch (e) {
      debugPrint("❌ Error fetch client: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _pickAndUploadLogo() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = await MultipartFile.fromFile(picked.path);
      await MasterClientService().updateClient(_client!, logo: file);
      final updated = await MasterClientService().getClient();
      setState(() => _client = updated);
    }
  }

  Future<void> _pickAndUploadBackground() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = await MultipartFile.fromFile(picked.path);
      await MasterClientService().updateClient(_client!, background: file);
      final updated = await MasterClientService().getClient();
      setState(() => _client = updated);
    }
  }

  Future<void> _pickAndUploadSound() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'aac'],
      );

      if (result != null && result.files.isNotEmpty) {
        final filePath = result.files.single.path;
        if (filePath != null) {
          final file = await MultipartFile.fromFile(filePath);
          await MasterClientService().updateClient(_client!, soundAlert: file);

          final updated = await MasterClientService().getClient();
          setState(() => _client = updated);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Sound berhasil diupload")),
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Error upload sound: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal upload sound: $e")),
      );
    }
  }

  Future<void> _save() async {
    if (_client == null) return;

    final updated = _client!.copyWith(
      name: nameCtrl.text,
      location: locationCtrl.text,
      timezone: timezoneCtrl.text,
      configTitle: titleCtrl.text,
      runningText: runningTextCtrl.text.isEmpty ? null : runningTextCtrl.text,
      enableHadis: _client!.enableHadis,
      enableHariBesar: _client!.enableHariBesar,
      enableKalender: _client!.enableKalender,
    );

    await MasterClientService().updateClient(updated);
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_client == null) {
      return const Scaffold(
          body: Center(child: Text("Data client tidak tersedia")));
    }

    return Scaffold(
appBar: AppBar(
  title: const Text("Kembali"),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => Navigator.pop(context, 'dashboard'),
  ),
  bottom: PreferredSize(
    preferredSize: const Size.fromHeight(48),
    child: Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Data Masjid"),
            Tab(text: "Data File"),
          ],
        ),
        const Divider(height: 1, color: Colors.white), // ✅ garis pemisah
      ],
    ),
  ),
),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Data Masjid
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FormCard(
                title: "Data Masjid",
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: "Nama Masjid",
                      hintText: "Masjid Al-Falah",
                      prefixIcon: const Icon(Icons.home),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: locationCtrl,
                    decoration: InputDecoration(
                      labelText: "Alamat Masjid",
                      hintText: "Alamat lengkap masjid",
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: timezoneCtrl,
                    decoration: InputDecoration(
                      labelText: "Zona Waktu",
                      hintText: "Asia/Jakarta",
                      prefixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: "Konfigurasi Title",
                      hintText: "Judul tampilan layar",
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: runningTextCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Running Text",
                      hintText: "Teks berjalan di layar masjid",
                      prefixIcon: const Icon(Icons.text_fields),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

                // Tab 2: Data File (styling sesuai mockup)
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: FormCard(
                    title: "Data File",
                    children: [
                      // Logo
                      Text("Logo",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      UploadCard(
                        imageUrl: _client?.logoUrl,
                        onPickFile: _pickAndUploadLogo,
                        height: 120,
                      ),
                      const Divider(height: 32),

                      // Background
                      Text("Background",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      UploadCard(
                        imageUrl: _client?.backgroundUrl,
                        onPickFile: _pickAndUploadBackground,
                        height: 180,
                      ),
                      const Divider(height: 32),

                      // Sound Alert
                      Text("Sound Alert",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.music_note),
                        title: Text(
                          _client?.soundUrl?.split("/").last ??
                              "Belum ada file audio",
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: ElevatedButton(
                          onPressed: _pickAndUploadSound,
                          child: const Text("Ganti Audio"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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