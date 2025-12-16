import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../dashboard/dashboard_page.dart';
import 'login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<bool> _hasToken() async {
    final token = await AuthService().getSavedToken(); 
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == true) {
          return const DashboardPage(); // langsung ke dashboard
        } else {
          return const LoginPage(); // kalau token kosong, ke login
        }
      },
    );
  }
}