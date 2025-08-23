import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../models/wheel_spec.dart';
import 'add_wheel_spec_screen.dart';
import 'bogie_checksheet_screen.dart';

class WheelSpecsScreen extends StatefulWidget {
  final ApiClient api;
  const WheelSpecsScreen({super.key, required this.api});

  @override
  State<WheelSpecsScreen> createState() => _WheelSpecsScreenState();
}

class _WheelSpecsScreenState extends State<WheelSpecsScreen> {
  Future<List<WheelSpec>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<WheelSpec>> _load() async {
    final list = await widget.api.listWheelSpecs();
    return list.map((e) => WheelSpec.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wheel Specifications'), actions: [
        IconButton(
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddWheelSpecScreen(api: widget.api),
            ));
            setState(() { _future = _load(); });
          },
          icon: const Icon(Icons.add),
          tooltip: 'Add/Upsert Spec',
        ),
        IconButton(
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BogieChecksheetScreen(api: widget.api),
            ));
          },
          icon: const Icon(Icons.assignment),
          tooltip: 'Create Bogie Checksheet',
        )
      ]),
      body: FutureBuilder<List<WheelSpec>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No specs yet. Tap + to add.'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final s = items[i];
              return ListTile(
                title: Text('${s.wheelCode} • ${s.diameterMm} mm'),
                subtitle: Text('${s.material} • ${s.manufacturer}${s.notes != null ? '\n' + s.notes! : ''}'),
              );
            },
          );
        },
      ),
    );
  }
}
