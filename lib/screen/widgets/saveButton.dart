import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final Future<void> Function() onSave; // pakai Future biar bisa async

  const SaveButton({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.save),
        label: const Text("Simpan"),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Konfirmasi"),
              content: const Text("Apakah yakin dengan perubahan ini?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx), // batal
                  child: const Text("Tidak"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx); // tutup konfirmasi
                    await onSave(); // jalankan logic simpan dari form

                    // tampilkan alert sukses
                    showDialog(
                      context: context,
                      builder: (ctx2) => AlertDialog(
                        title: const Text("Berhasil"),
                        content: const Text("Perubahan telah disimpan"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx2); // tutup dialog sukses
                              Navigator.pop(context, true); // balik ke list page
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text("Ya"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}