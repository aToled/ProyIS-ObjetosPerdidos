import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class JsonManager {
  late String _fileName;

  JsonManager(String fileNameWithExtension) {
    _fileName = fileNameWithExtension;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<Map<String, dynamic>> readJson() async {
    String fileContent = "";
    File jsonFile = await _localFile;

    try {
      fileContent = await jsonFile.readAsString();
    } catch (e) {
      jsonFile.writeAsString("{}");
      fileContent = await jsonFile.readAsString();
    }

    return json.decode(fileContent);
  }

  Future<void> writeJson(Map<String, dynamic> jsonMap) async {
    File jsonFile = await _localFile;

    await jsonFile.writeAsString(json.encode(jsonMap));
  }
}