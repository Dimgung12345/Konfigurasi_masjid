import 'package:flutter/material.dart';
import '../../../core/models/rekap.dart';
import 'package:intl/intl.dart';

class MonthlyRecapCard extends StatelessWidget {
  final MonthlyBalance recap;
  final VoidCallback? onDetail;
  final VoidCallback? onDownload;

  const MonthlyRecapCard({
    super.key,
    required this.recap,
    this.onDetail,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {

  final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rekap Bulan : ${(recap.month)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            const SizedBox(height: 8),
            Text("Penerimaan: ${currencyFormat.format(recap.totalIncome)}"),
            Text("Pengeluaran: ${currencyFormat.format(recap.totalExpense)}"),
            Text("Saldo Akhir: ${currencyFormat.format(recap.closingBalance)}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onDetail, child: const Text("Detail")),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onDownload,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Set as PDF"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SkeletonMonthlyRecapCard extends StatelessWidget {
  const SkeletonMonthlyRecapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 150, height: 16, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Container(width: 200, height: 14, color: Colors.grey.shade300),
            const SizedBox(height: 4),
            Container(width: 200, height: 14, color: Colors.grey.shade300),
            const SizedBox(height: 4),
            Container(width: 200, height: 14, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(width: 60, height: 20, color: Colors.grey.shade300),
                const SizedBox(width: 8),
                Container(width: 100, height: 32, color: Colors.grey.shade300),
              ],
            )
          ],
        ),
      ),
    );
  }
}