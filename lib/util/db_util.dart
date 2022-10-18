import 'dart:io';

import 'package:ai_prompt_organizer/ai_prompt_organizer.dart';
import 'package:path/path.dart';


class DBUtil {
  static Future<Directory> getDatabaseFolder() async {
    final exeFolderPath = File(Platform.resolvedExecutable).parent.path;
    final dbDir = Directory("$exeFolderPath/${AIPromptOrganizer.baseDBFolderName}");

    if(!await dbDir.exists()){
      await dbDir.create();
    }

    return dbDir;
  }

  static Future<Directory> getImageFolder() async {
    final dbDir = await getDatabaseFolder();
    final imgFolder = Directory("${dbDir.path}/${AIPromptOrganizer.imageFolderName}");

    if(!await imgFolder.exists()){
      await imgFolder.create();
    }

    return imgFolder;
  }

  static Future<String> getImageFullPath(String relativePath) async {
    relativePath = basename(relativePath);
    final imgDir = await getImageFolder();
    final imgFilePath = "${imgDir.path}/$relativePath";
    if (await File(imgFilePath).exists()) {
      return imgFilePath;
    }

    return Future.error("Image not found.");
  }
}