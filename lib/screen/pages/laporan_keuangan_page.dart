import 'package:dashboard_masjid/screen/widgets/DisconectWidget.dart';
import 'package:dashboard_masjid/screen/widgets/finance/realtime_saldo.dart';
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
  bool _loadingBalance = true;
  bool _loadingTx = true;
  bool _error = false;
  bool showSkeleton = false;
  Balance? _balance;
  List<FinancialTransaction> _transactions = [];
  List<FinanceCard> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

Future<void> _loadData() async {
  setState(() {
    _loadingBalance = true;
    _loadingTx = true;
    _error = false;
    showSkeleton = false;
  });

  // Skeleton muncul kalau loading > 1 detik
  Future.delayed(const Duration(seconds: 1), () {
    if ((_loadingBalance || _loadingTx) && mounted) {
      setState(() => showSkeleton = true);
    }
  });

  // Error page muncul kalau loading > 5 detik
  Future.delayed(const Duration(seconds: 5), () {
    if ((_loadingBalance || _loadingTx) && mounted) {
      setState(() {
        _error = true;
        _loadingBalance = false;
        _loadingTx = false;
      });
    }
  });

  try {
    final now = DateTime.now();
    final monthParam = DateFormat("yyyy-MM").format(now);

    final txs = await _service.getTransactions(monthParam);
    final bal = await _service.getRealtimeBalance(monthParam);
    final cards = await _service.getCards();

    setState(() {
      _transactions = txs;
      _balance = bal;
      _cards = cards;
      _loadingBalance = false;
      _loadingTx = false;
      _error = false;
      showSkeleton = false;
    });
  } catch (e) {
    setState(() {
      _loadingBalance = false;
      _loadingTx = false;
      _error = true;
      showSkeleton = true;
    });
  }
}

  @override
  Widget build(BuildContext context) {
      if (_error) {
    return ConnectionErrorWidget(onRetry: _loadData);
  }

  if ((_loadingBalance || _loadingTx) && showSkeleton) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          SkeletonBalanceSummary(),
          SizedBox(height: 8),
          SkeletonTransactionCard(),
          SkeletonTransactionCard(),
          SkeletonTransactionCard(),
        ],
      ),
    );
  }

    return Scaffold(
      body: _loadingBalance || _loadingTx
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