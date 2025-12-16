import 'package:flutter/material.dart';
import 'core/models/master_client.dart';
import 'screen/login/login_page.dart';
import 'screen/dashboard/dashboard_page.dart';
import 'screen/edit/edit_client_page.dart';
import 'screen/login/auth_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Masjid Control Panel',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const AuthWrapper(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),

        // 👉 Dashboard tidak perlu lagi arguments clientId
        '/dashboard': (context) => const DashboardPage(),

        // Edit tetap butuh client object, karena memang FE perlu isi form
        '/editMasterClient': (context) {
          final client = ModalRoute.of(context)!.settings.arguments as MasterClient;
          return EditMasterClientPage(client: client);
        },
      },
    );
  }
}