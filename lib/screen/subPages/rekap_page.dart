import 'package:flutter/material.dart';
import '../../core/models/rekap.dart';
import '../../core/services/finance_service.dart';
import '../widgets/finance/rekap_card.dart';
import 'rekap_detail_page.dart';

class MonthlyRecapPage extends StatelessWidget {
  const MonthlyRecapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FinanceService();

    return FutureBuilder<List<MonthlyBalance>>(
      future: service.getMonthlyRecap(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("❌ Gagal memuat data"));
        }
        final recaps = snapshot.data?.take(6).toList() ?? [];
        if (recaps.isEmpty) {
          return const Center(child: Text("Belum ada rekap bulanan"));
        }
        return ListView.builder(
          itemCount: recaps.length,
          itemBuilder: (context, index) {
            final recap = recaps[index];
            return MonthlyRecapCard(
              recap: recap,
              onDetail: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MonthlyRecapDetailPage(recap: recap),
                ),
              ),
            );
          },
        );
      },
    );
  }
}