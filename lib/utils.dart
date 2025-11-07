import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<File> _getConfigFile() async {
  final dir = await getApplicationSupportDirectory(); // e.g. ~/.local/share/com.example.app/
  print("Application support directory: ${dir.path} ");
  return File('${dir.path}/dosbox_path.txt');
}

Future<String?> loadConfigPath() async {
  final file = await _getConfigFile();
  if (await file.exists()) {
    final path = (await file.readAsString()).trim();
    return path.isNotEmpty ? path : null;
  }
  return null;
}

Future<void> saveConfigPath(String path) async {
  final file = await _getConfigFile();
  await file.writeAsString(path);
}
