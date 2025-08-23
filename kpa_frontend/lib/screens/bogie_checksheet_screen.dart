import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_client.dart';

class BogieChecksheetScreen extends StatefulWidget {
  final ApiClient api;
  const BogieChecksheetScreen({super.key, required this.api});

  @override
  State<BogieChecksheetScreen> createState() => _BogieChecksheetScreenState();
}

class _BogieChecksheetScreenState extends State<BogieChecksheetScreen> {
  final _formNo = TextEditingController(text: 'KPA-BC-0001');
  final _submittedBy = TextEditingController(text: 'Inspector A');

  // Simple JSON editor textfield for the nested payload
  final _jsonCtrl = TextEditingController(text: const JsonEncoder.withIndent('  ').convert({
    'bogie_id': 'BG-7788',
    'date': '2025-08-22',
    'wheels': [
      {'position': 'L1', 'thickness': 32.1},
      {'position': 'R1', 'thickness': 31.9}
    ],
    'remarks': 'OK'
  }));

  String? _result;
  bool _busy = false;

  Future<void> _submit() async {
    setState(() { _busy = true; _result = null; });
    try {
      final parsed = jsonDecode(_jsonCtrl.text) as Map<String, dynamic>;
      final body = {
        'form_no': _formNo.text.trim().isEmpty ? null : _formNo.text.trim(),
        'submitted_by': _submittedBy.text.trim().isEmpty ? null : _submittedBy.text.trim(),
        'data': parsed,
      }..removeWhere((k, v) => v == null);

      final res = await widget.api.createBogieChecksheet(body);
      setState(() { _result = const JsonEncoder.withIndent('  ').convert(res); });
    } catch (e) {
      setState(() { _result = 'Error: $e'; });
    } finally {
      setState(() { _busy = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Bogie Checksheet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _formNo, decoration: const InputDecoration(labelText: 'Form No. (optional)')),
            TextField(controller: _submittedBy, decoration: const InputDecoration(labelText: 'Submitted By (optional)')),
            const SizedBox(height: 12),
            const Align(alignment: Alignment.centerLeft, child: Text('JSON Payload (data):')),
            Expanded(
              child: TextField(
                controller: _jsonCtrl,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _busy ? null : _submit, child: _busy ? const CircularProgressIndicator() : const Text('Submit')),
            const SizedBox(height: 12),
            if (_result != null)
              Expanded(
                child: SingleChildScrollView(
                  child: SelectableText(_result!),
                ),
              )
          ],
        ),
      ),
    );
  }
}
