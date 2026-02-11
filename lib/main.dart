import 'package:flutter/material.dart';
import 'core/models/master_client.dart';
import 'screen/login/login_page.dart';
import 'screen/dashboard/dashboard_page.dart';
import 'screen/pages/edit_client_page.dart';
import 'screen/login/auth_wrapper.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = ThemeData(
      primaryColor: const Color(0xFFFF9D00), // base orange
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF9D00),
        primary: const Color(0xFFFF9D00),
        secondary: const Color(0xFFF1BF00),
        background: Colors.white,
        surface: Colors.white,
        error: Colors.red,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFF9D00),
        foregroundColor: Colors.white,
        elevation: 0,     
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFF9D00),
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9D00),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Masjid Control Panel',
      theme: appTheme,
      home: const AuthWrapper(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/editMasterClient': (context) {
          final client = ModalRoute.of(context)!.settings.arguments as MasterClient;
          return EditMasterClientPage(client: client);
        },
      },
    );
  }
}