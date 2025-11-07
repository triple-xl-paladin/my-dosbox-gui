import 'dart:io';
import 'package:flutter/material.dart';
import 'config_entry.dart';

class ConfigListScreen extends StatefulWidget {
  final String rootDir;

  const ConfigListScreen({super.key, required this.rootDir});

  @override
  State<ConfigListScreen> createState() => _ConfigListScreenState();
}

class _ConfigListScreenState extends State<ConfigListScreen> {
  List<ConfigEntry> _configs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    setState(() => _isLoading = true);

    final dir = Directory(widget.rootDir);
    if (!dir.existsSync()) {
      setState(() {
        _configs = [];
        _isLoading = false;
      });
      return;
    }

    List<ConfigEntry> confFiles = [];

    try {
      confFiles = dir
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((f) => f.path.toLowerCase().endsWith('.conf'))
          .map((f) =>
          ConfigEntry(
            name: f.uri.pathSegments.last.replaceAll('.conf', ''),
            path: f.path,
          ))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name)); // alphabetic sort
    } catch (e) {
      debugPrint('Error reading config directory: $e');

    }

    setState(() {
      _configs = confFiles;
      _isLoading = false;
    });
  }

  void _launchGame(ConfigEntry entry) async {
    try {
      await Process.start(
        'dosbox',
        ['-conf', entry.path],
        mode: ProcessStartMode.detached,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching ${entry.name}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DOSBox Game Launcher'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConfigs,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _configs.isEmpty
          ? const Center(child: Text('No config files found'))
          : ListView.builder(
        itemCount: _configs.length,
        itemBuilder: (context, index) {
          final entry = _configs[index];
          return ListTile(
            title: Text(entry.name),
            subtitle: Text(entry.path),
            leading: const Icon(Icons.insert_drive_file),
            trailing: const Icon(Icons.play_arrow),
            onTap: () => _launchGame(entry),
          );
        },
      ),
    );
  }
}
