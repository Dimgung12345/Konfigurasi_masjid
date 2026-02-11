import 'package:flutter/material.dart';
import '../subPages/card_page.dart';
import '../subPages/rekap_page.dart';
import 'laporan_keuangan_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  final _pages = [
    const FinanceCardsPage(),   // Rekening
    const MonthlyRecapPage(),   // Rekap Bulanan
    const FinanceReportPage(),  // Laporan Keuangan
  ];

  final _titles = [
    "Daftar Rekening",
    "Rekap Bulanan",
    "Laporan Keuangan",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // ✅ langsung balik ke Dashboard
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: "Rekening"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Rekap"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Laporan"),
        ],
      ),
    );
  }
}