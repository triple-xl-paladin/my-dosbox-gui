/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file utils.dart is part of my_dosbox_gui
 *
 * my_dosbox_gui is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * my_dosbox_gui is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with my_dosbox_gui.  If not, see <https://www.gnu.org/licenses/>.
 */

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
