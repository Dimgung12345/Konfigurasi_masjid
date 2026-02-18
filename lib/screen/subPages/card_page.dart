import 'package:flutter/material.dart';
import '../../core/models/rekening.dart';
import '../../core/services/finance_service.dart';
import '../widgets/finance/rekening_card.dart';
import '../todoPages/createCardPage.dart';
import '../todoPages/editCardPage.dart';
import '../widgets/DisconectWidget.dart';

class FinanceCardsPage extends StatefulWidget {
  const FinanceCardsPage({super.key});

  @override
  State<FinanceCardsPage> createState() => _FinanceCardsPageState();
}

class _FinanceCardsPageState extends State<FinanceCardsPage> {
  final FinanceService _service = FinanceService();
  List<FinanceCard> _cards = [];
  bool _loading = true;
  bool _error = false;
  bool showSkeleton = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() {
      _loading = true;
      _error = false;
      showSkeleton = false;
    });

    // Skeleton muncul kalau loading > 1 detik
    Future.delayed(const Duration(seconds: 1), () {
      if (_loading && mounted) {
        setState(() => showSkeleton = true);
      }
    });

    // Error page muncul kalau loading > 5 detik
    Future.delayed(const Duration(seconds: 5), () {
      if (_loading && mounted) {
        setState(() {
          _error = true;
          _loading = false;
        });
      }
    });

    try {
      final cards = await _service.getCards();
      setState(() {
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

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return ConnectionErrorWidget(onRetry: _loadCards); // error page mockup
    }

    if (_loading && showSkeleton) {
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (_, __) => const SkeletonFinanceCard(),
      );
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: _cards.length,
          itemBuilder: (context, index) {
            final card = _cards[index];
            return FinanceCardWidget(
              card: card,
            onEdit: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditCardPage(card: card)),
              );
              if (result == true) {
                _loadCards(); // refresh data setelah edit
              }
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
                _loadCards(); // reload daftar kartu setelah tambah
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