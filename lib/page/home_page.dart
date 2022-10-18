import 'dart:io';

import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../model/schema/prompt.dart';
import '../util/db_util.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Prompt> promptList = List.empty();
  final List<String> imagePathList = List.empty();
  final int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: '画像を追加',
        child: const Icon(Icons.add),
      ),
    );
  }

  void pickImage() async {
    final filePaths = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (filePaths == null) {
      return;
    }
    for (var item in filePaths.paths) {
      if (item != null) {
        setState(() {
          copyImageFile(item);
        });
      }
    }
  }

  void copyImageFile(String imagePath) async {
    final originalFile = File(imagePath);
    final imgDir = await DBUtil.getImageFolder();
    final targetImgPath = "${imgDir.path}/${basename(imagePath)}";

    await originalFile.copy(targetImgPath);
  }
}
