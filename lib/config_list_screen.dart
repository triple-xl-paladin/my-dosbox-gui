import 'dart:io';
import 'package:flutter/material.dart';
import 'config_entry.dart';

class ConfigListScreen extends StatefulWidget {
  final String configDir;

  const ConfigListScreen({super.key, required this.configDir});

  @override
  State<ConfigListScreen> createState() => _ConfigListScreenState();
}

class _ConfigListScreenState extends State<ConfigListScreen> {
  List<ConfigEntry> _configs = [];

  @override
  void initState() {
    super.initState();
    _loadConfigs();
  }

  void _loadConfigs() {
    final dir = Directory(widget.configDir);
    if (!dir.existsSync()) return;
    final files = dir
        .listSync()
        .where((f) => f.path.endsWith('.conf'))
        .map((f) => ConfigEntry(
      name: f.uri.pathSegments.last.replaceAll('.conf', ''),
      path: f.path,
    ))
        .toList();
    setState(() => _configs = files);
  }

  void _loadConfigsScan() {
    final dir = Directory(widget.configDir);
    if (!dir.existsSync()) return;

    final files = dir
        .listSync(recursive: true)
        .where((f) => f is File && f.path.endsWith('.conf'))
        .map((f) => ConfigEntry(
      name: f.uri.pathSegments.last.replaceAll('.conf', ''),
      path: f.path,
    ))
        .toList();

    setState(() => _configs = files);
  }

  void _launchGame(ConfigEntry entry) async {
    final result = await Process.start(
      'dosbox',
      ['-conf', entry.path],
      mode: ProcessStartMode.detached,
    );
    // You could log or handle errors here if needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DOSBox Game Launcher')),
      body: ListView.builder(
        itemCount: _configs.length,
        itemBuilder: (context, index) {
          final entry = _configs[index];
          return ListTile(
            title: Text(entry.name),
            subtitle: Text(entry.path),
            trailing: const Icon(Icons.play_arrow),
            onTap: () => _launchGame(entry),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadConfigs,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
