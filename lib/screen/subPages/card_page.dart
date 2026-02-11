import 'package:flutter/material.dart';
import '../../core/models/rekening.dart';
import '../../core/services/finance_service.dart';
import '../widgets/finance/rekening_card.dart';
import '../todoPages/createCardPage.dart';
import '../todoPages/editCardPage.dart';

class FinanceCardsPage extends StatefulWidget {
  const FinanceCardsPage({super.key});

  @override
  State<FinanceCardsPage> createState() => _FinanceCardsPageState();
}

class _FinanceCardsPageState extends State<FinanceCardsPage> {
  final FinanceService _service = FinanceService();
  List<FinanceCard> _cards = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await _service.getCards();
    setState(() {
      _cards = cards;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              ListView.builder(
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return FinanceCardWidget(
                    card: card,
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditCardPage(card: card),
                        ),
                      );
                    },
                    onDelete: () async {
                      await _service.deleteCard(card.id);
                      _loadCards();
                    },
                  );
                },
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateCardPage()),
                    );
                    if (result == true) {
                      _loadCards(); // muat ulang daftar kartu setelah penambahan
                    }
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          );
  }
}