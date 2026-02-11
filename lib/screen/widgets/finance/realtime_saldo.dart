import 'package:flutter/material.dart';
import '../../../core/models/balance.dart';
import 'package:intl/intl.dart';

class BalanceSummaryWidget extends StatelessWidget {
  final Balance balance;

  const BalanceSummaryWidget({super.key, required this.balance});

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
          Text("Saldo Akhir Bulan: ${currencyFormat.format(balance.closing)}", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text("Saldo Awal: ${currencyFormat.format(balance.opening)}"),
          Text("Penerimaan: ${currencyFormat.format(balance.income)}"),
          Text("Pengeluaran: ${currencyFormat.format(balance.expense)}"),
        ],
      ),
    ),
  );
}
}