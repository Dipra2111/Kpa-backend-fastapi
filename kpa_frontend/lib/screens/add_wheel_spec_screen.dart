import 'package:flutter/material.dart';
import '../services/api_client.dart';

class AddWheelSpecScreen extends StatefulWidget {
  final ApiClient api;
  const AddWheelSpecScreen({super.key, required this.api});

  @override
  State<AddWheelSpecScreen> createState() => _AddWheelSpecScreenState();
}

class _AddWheelSpecScreenState extends State<AddWheelSpecScreen> {
  final _code = TextEditingController();
  final _dia = TextEditingController();
  final _mat = TextEditingController();
  final _mfg = TextEditingController();
  final _notes = TextEditingController();
  bool _busy = false;
  String? _msg;

  Future<void> _save() async {
    setState(() { _busy = true; _msg = null; });
    try {
      await widget.api.upsertWheelSpec({
        'wheel_code': _code.text.trim(),
        'diameter_mm': int.tryParse(_dia.text.trim()) ?? 0,
        'material': _mat.text.trim(),
        'manufacturer': _mfg.text.trim(),
        'notes': _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      });
      if (mounted) {
        setState(() { _msg = 'Saved!'; });
      }
    } catch (e) {
      setState(() { _msg = 'Error: $e'; });
    } finally {
      setState(() { _busy = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add / Upsert Wheel Spec')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _code, decoration: const InputDecoration(labelText: 'Wheel Code *')),
            TextField(controller: _dia, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Diameter (mm) *')),
            TextField(controller: _mat, decoration: const InputDecoration(labelText: 'Material *')),
            TextField(controller: _mfg, decoration: const InputDecoration(labelText: 'Manufacturer *')),
            TextField(controller: _notes, decoration: const InputDecoration(labelText: 'Notes')),
            const SizedBox(height: 16),
            if (_msg != null) Text(_msg!),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _busy ? null : _save, child: _busy ? const CircularProgressIndicator() : const Text('Save'))
          ],
        ),
      ),
    );
  }
}
