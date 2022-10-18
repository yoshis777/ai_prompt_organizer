import 'dart:io';

import 'package:ai_prompt_organizer/repository/prompt_repository.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../ai_prompt_organizer.dart';
import '../model/schema/prompt.dart';
import '../util/db_util.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Prompt> promptList = List.empty();
  final List<String> imagePathList = List.empty();

  Future<bool> loadPromptFromDB() async {
    final repository = await PromptRepository.getInstance();

    // TODO: DB変更後のリスナーを設定

    final list = repository.getAllPrompts();
    if (list != null) {
      promptList = list;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: loadPromptFromDB(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: promptList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: buildPromptWidget(promptList[index]),
                  );
                }
              );
            } else {
              return const Text(ErrorMessage.dbReadingError);
            }
          } else {
            return const Text(StateMessage.dbReading);
          }
        })
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickImage(context);
        },
        tooltip: '画像を追加',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildPromptWidget(Prompt prompt) {
    final promptTextController = TextEditingController();
    promptTextController.text = prompt.prompt;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200, height:200,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  FutureBuilder(
                    future: DBUtil.getImageFullPath(prompt.imageData!.imagePath),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (!snapshot.hasError) {
                          return Image.file(File(snapshot.data!));
                        } else {
                          return Text("${ErrorMessage.someError}: ${snapshot.error}");
                        }
                      } else {
                        return const Text(StateMessage.imageReading);
                      }
                    },
                  ),
                ],
              )
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: double.infinity),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      labelText: "prompt",
                    ),
                    maxLines: 2,
                    controller: promptTextController,
                    onChanged: (value) {
                      // TODO: 定期的にDB反映
                    },
                  ),
                ]
              ),
            )
          ],
        ),
      )
    );
  }

  Future<void> pickImage(BuildContext context) async {
    final filePaths = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (filePaths == null) {
      return;
    }
    for (var item in filePaths.paths) {
      if (item != null) {
        setState(() async {
          try {
            await saveImage(item);
          } catch(e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.toString()),
              duration: const Duration(seconds: 3),
            ));
          }
        });
      }
    }
  }

  Future<void> saveImage(String imagePath) async {
    String targetImgPath = await copyImageFile(imagePath);

    final prompt = Prompt(
      Uuid.v4(),
      "", "", "", "",
      DateTime.now(), DateTime.now()
    );
    prompt.imageData = ImageData(Uuid.v4(), targetImgPath);
    final repository = await PromptRepository.getInstance();
    repository.addPrompt(prompt);
  }

  Future<String> copyImageFile(String imagePath) async {
    final originalFile = File(imagePath);
    final imgDir = await DBUtil.getImageFolder();
    final targetImgPath = "${imgDir.path}/${basename(imagePath)}";
    if (await File(targetImgPath).exists()) {
      return Future.error(ErrorMessage.fileExists + basename(imagePath));
    }

    await originalFile.copy(targetImgPath);
    return targetImgPath;
  }
}
