import 'package:flutter/material.dart';
import '../../../core/models/rekening.dart';
import 'package:intl/intl.dart';

class FinanceCardWidget extends StatelessWidget {
  final FinanceCard card;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const FinanceCardWidget({
    super.key,
    required this.card,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

  final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(card.cardName,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Saldo = ${currencyFormat.format(card.currentBalance)}",
                style: const TextStyle(fontSize: 14)),
            Text("Status = ${card.status}", style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(     
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text("edit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text("Hapus"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SkeletonFinanceCard extends StatelessWidget {
  const SkeletonFinanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 120, height: 16, color: Colors.grey.shade300),
            const SizedBox(height: 4),
            Container(width: 180, height: 14, color: Colors.grey.shade300),
            const SizedBox(height: 4),
            Container(width: 140, height: 14, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(width: 80, height: 32, color: Colors.grey.shade300),
                const SizedBox(width: 8),
                Container(width: 80, height: 32, color: Colors.grey.shade300),
              ],
            )
          ],
        ),
      ),
    );
  }
}