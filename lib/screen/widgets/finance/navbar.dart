import 'package:flutter/material.dart';

class FinanceBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const FinanceBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance),
          label: "Rekening",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: "Transaksi",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: "Rekap",
        ),
      ],
    );
  }
}