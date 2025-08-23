import 'package:flutter/material.dart';
import 'services/api_client.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const KpaApp());
}

class KpaApp extends StatelessWidget {
  const KpaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiClient();
    return MaterialApp(
      title: 'KPA Frontend',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: LoginScreen(api: api),
    );
  }
}
