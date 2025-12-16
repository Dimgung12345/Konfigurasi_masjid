import 'package:flutter/material.dart';
import '../../core/models/hadist.dart';
import '../../core/models/client_hadist.dart';

class HadistCard extends StatelessWidget {
  final Hadist hadist;
  final ClientHadist clientHadist;
  final void Function(ClientHadist, bool) onToggle;

  const HadistCard({
    super.key,
    required this.hadist,
    required this.clientHadist,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF6E3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade400),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hadist.konten,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "${hadist.riwayat ?? ''}\n${hadist.kitab ?? ''}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Switch(
              value: !clientHadist.disabled,
              activeColor: Colors.orange,
              onChanged: (val) {
                onToggle(clientHadist, !val); // kirim ClientHadist + status
              },
            ),
          ),
        ],
      ),
    );
  }
}