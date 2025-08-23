import 'package:flutter/material.dart';
import '../services/api_client.dart';
import 'wheel_specs_screen.dart';

class LoginScreen extends StatefulWidget {
  final ApiClient api;
  const LoginScreen({super.key, required this.api});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController(text: '7760873976');
  final _passCtrl = TextEditingController(text: 'to_share@123');
  bool _busy = false;
  String? _error;

  Future<void> _login() async {
    setState(() { _busy = true; _error = null; });
    try {
      await widget.api.login(phone: _phoneCtrl.text.trim(), password: _passCtrl.text);
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => WheelSpecsScreen(api: widget.api),
        ));
      }
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _busy = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KPA Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
            const SizedBox(height: 12),
            TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 20),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _busy ? null : _login,
              child: _busy ? const CircularProgressIndicator() : const Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
