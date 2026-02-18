import 'package:flutter/material.dart';
import '../../core/models/rekap.dart';
import '../../core/services/finance_service.dart';
import '../widgets/finance/rekap_card.dart';
import 'rekap_detail_page.dart';
import '../widgets/DisconectWidget.dart';

class MonthlyRecapPage extends StatefulWidget {
  const MonthlyRecapPage({super.key});

  @override
  State<MonthlyRecapPage> createState() => _MonthlyRecapPageState();
}

class _MonthlyRecapPageState extends State<MonthlyRecapPage> {
  final FinanceService _service = FinanceService();
  List<MonthlyBalance> _recaps = [];
  bool _loading = true;
  bool _error = false;
  bool showSkeleton = false;

  @override
  void initState() {
    super.initState();
    _loadRecaps();
  }

  Future<void> _loadRecaps() async {
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
      final recaps = await _service.getMonthlyRecap();
      setState(() {
        _recaps = recaps.take(6).toList();
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
    if (_error) return ConnectionErrorWidget(onRetry: _loadRecaps);

    if (_loading && showSkeleton) {
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (_, __) => const SkeletonMonthlyRecapCard(),
      );
    }

    if (_recaps.isEmpty) {
      return const Center(child: Text("Belum ada rekap bulanan"));
    }

    return ListView.builder(
      itemCount: _recaps.length,
      itemBuilder: (context, index) {
        final recap = _recaps[index];
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
  }
}