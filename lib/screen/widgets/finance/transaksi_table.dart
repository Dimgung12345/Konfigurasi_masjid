import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/data_transakasi.dart';

class TransactionCardWidget extends StatelessWidget {
  final FinancialTransaction tx;
  final String cardName;

  const TransactionCardWidget({
    super.key,
    required this.tx,
    required this.cardName,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    final isIncome = tx.isIncome;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tx.date.toLocal().toString().split(' ')[0],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Jenis: ${isIncome ? "Penerimaan" : "Pengeluaran"}"),
            Text("Keterangan: ${tx.description ?? "-"}"),
            Text("Nominal: ${currencyFormat.format(tx.amount)}",
                style: TextStyle(
                  color: isIncome ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.w600,
                )),
            Text("Kartu: $cardName"),
          ],
        ),
      ),
    );
  }
}

class SkeletonTransactionCard extends StatelessWidget {
  const SkeletonTransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 100, height: 14, color: Colors.grey.shade300),
            const SizedBox(height: 4),
            Container(width: 160, height: 14, color: Colors.grey.shade300),
            const SizedBox(height: 4),
            Container(width: 200, height: 14, color: Colors.grey.shade300),
            const SizedBox(height: 4),
            Container(width: 120, height: 14, color: Colors.grey.shade300),
            const SizedBox(height: 4),
            Container(width: 140, height: 14, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}