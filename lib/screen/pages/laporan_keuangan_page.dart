import 'package:flutter/material.dart';
import '../../core/services/finance_service.dart';
import '../../core/models/data_transakasi.dart';
import '../../core/models/balance.dart';
import '../../core/models/rekening.dart';
import '../subPages/transaksi_form.dart';
import '../widgets/finance/transaksi_table.dart';
import 'package:intl/intl.dart';

class FinanceReportPage extends StatefulWidget {
  const FinanceReportPage({super.key});

  @override
  State<FinanceReportPage> createState() => _FinanceReportPageState();
}

class _FinanceReportPageState extends State<FinanceReportPage> {
  final FinanceService _service = FinanceService();
  List<FinancialTransaction> _transactions = [];
  List<FinanceCard> _cards = [];
  Balance? _balance;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

Future<void> _loadData() async {
  try {
    // ambil bulan aktif (YYYY-MM)
    final now = DateTime.now();
    final monthParam = DateFormat("yyyy-MM").format(now);

    final txs = await _service.getTransactions(monthParam);
    final bal = await _service.getRealtimeBalance(monthParam);
    final cards = await _service.getCards();

    setState(() {
      _transactions = txs;
      _balance = bal;
      _cards = cards;
      _loading = false;
    });
  } catch (e) {
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gagal memuat data keuangan")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (_balance != null)
                    Card(
                      margin: const EdgeInsets.all(12),
                      child: ListTile(
                        title: Text(
                          "Saldo Akhir: ${currencyFormat.format(_balance!.closing)}",
                        ),
                        subtitle: Text(
                          "Saldo Awal: ${currencyFormat.format(_balance!.opening)} | "
                          "Pemasukan: ${currencyFormat.format(_balance!.income)} | "
                          "Pengeluaran: ${currencyFormat.format(_balance!.expense)}",
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final tx = _transactions[index];
                      final card = _cards.firstWhere(
                        (c) => c.id == tx.cardId,
                        orElse: () => FinanceCard(
                          id: tx.cardId,
                          clientId: '',
                          cardName: 'Tidak Diketahui',
                          status: '',
                          createdAt: DateTime.now(),
                          currentBalance: 0,
                        ),
                      );
                      return TransactionCardWidget(tx: tx, cardName: card.cardName);
                    },
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTransactionPage()),
          );
          if (result == true) {
            _loadData(); // muat ulang data jika ada transaksi baru
          }
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}