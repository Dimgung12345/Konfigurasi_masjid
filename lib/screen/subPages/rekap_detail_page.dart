import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/rekap.dart';
import '../../core/models/data_transakasi.dart';
import '../../core/models/rekening.dart';
import '../../core/services/finance_service.dart';
import '../widgets/finance/transaksi_table.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/DisconectWidget.dart';

class MonthlyRecapDetailPage extends StatefulWidget {
  final MonthlyBalance recap;

  const MonthlyRecapDetailPage({super.key, required this.recap});

  @override
  State<MonthlyRecapDetailPage> createState() => _MonthlyRecapDetailPageState();
}

class _MonthlyRecapDetailPageState extends State<MonthlyRecapDetailPage> {
  final FinanceService _service = FinanceService();
  List<FinancialTransaction> _transactions = [];
  List<FinanceCard> _cards = [];
  bool _loading = true;
  bool _error = false;
  bool showSkeleton = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

Future<void> _loadTransactions() async {
    setState(() {
      _loading = true;
      _error = false;
      showSkeleton = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (_loading && mounted) setState(() => showSkeleton = true);
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (_loading && mounted) {
        setState(() {
          _error = true;
          _loading = false;
        });
      }
    });

    try {
      final txs = await _service.getTransactions(widget.recap.month);
      final cards = await _service.getCards();
      setState(() {
        _transactions = txs;
        _cards = cards;
        _loading = false;
        _error = false;
        showSkeleton = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
        showSkeleton = true;
      });
    }
  }


Future<void> _showSuccessDialog(String filePath) async {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text("Berhasil"),
        ],
      ),
      content: Text("PDF berhasil disimpan:\n$filePath"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            OpenFilex.open(filePath); // buka PDF di reader user
          },
          child: const Text("Buka PDF"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            Share.shareXFiles([XFile(filePath)], text: "Rekap Bulanan Masjid");
          },
          child: const Text("Bagikan"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("Tutup"),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final r = widget.recap;
    final currencyFormat =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: Text("Rekap ${r.month}")),
      body: _error
            ? ConnectionErrorWidget(onRetry: _loadTransactions)
              : _loading && showSkeleton
                  ? ListView.builder(
                      itemCount: 5,
                      itemBuilder: (_, __) => const SkeletonTransactionCard(),
                    ) :
              _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // Header saldo recap
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Saldo Awal: ${currencyFormat.format(r.openingBalance)}"),
                        Text("Penerimaan: ${currencyFormat.format(r.totalIncome)}",
                            style: const TextStyle(color: Colors.green)),
                        Text("Pengeluaran: ${currencyFormat.format(r.totalExpense)}",
                            style: const TextStyle(color: Colors.red)),
                        const Divider(),
                        Text("Saldo Akhir: ${currencyFormat.format(r.closingBalance)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // List transaksi
                if (_transactions.isEmpty)
                  const Center(child: Text("Belum ada transaksi bulan ini"))
                else
                  ..._transactions.map((tx) {
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
                  }),
              ],
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Konfirmasi"),
                  content: Text("Anda yakin ingin menyimpan laporan ${r.month} sebagai PDF?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Tidak"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(ctx).pop();
                        try {
                          final file = await _service.downloadMonthlyRecapPDF(r.month);
                          _showSuccessDialog(file.path); // ⬅️ tampilkan alert sukses
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal menyimpan PDF: $e")),
                          );
                        }
                      },
                      child: const Text("Ya"),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.download, color: Colors.black, size: 32),
            ),
          ),
          const SizedBox(height: 4),
          const Text("Set As PDF",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}