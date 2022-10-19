import 'dart:io';

import 'package:ai_prompt_organizer/repository/prompt_repository.dart';
import 'package:flutter/services.dart';
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

    repository.streamController.stream.listen((event) {
      setState(() {
        promptList = event.toList();
      });
    });

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
                    padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
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
    final seedTextController = TextEditingController();
    seedTextController.text = prompt.seed;
    final stepsTextController = TextEditingController();
    stepsTextController.text = prompt.steps.toString();
    final scaleTextController = TextEditingController();
    scaleTextController.text = prompt.scale.toString();


    return Card(
      color: Colors.white70,
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                        labelText: "prompt",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 2,
                      controller: promptTextController,
                      onChanged: (value) async {
                        final repository = await PromptRepository.getInstance();
                        repository.update(() => {
                          prompt.prompt = value
                        });
                      },
                    ),
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 112,
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            labelText: "seed",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: 1,
                          controller: seedTextController,
                          onChanged: (value) async {
                            final repository = await PromptRepository.getInstance();
                            repository.update(() => {
                              prompt.seed = value
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(width: 60,
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            labelText: "steps",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: 1,
                          controller: stepsTextController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          onChanged: (value) async {
                            final repository = await PromptRepository.getInstance();
                            repository.update(() => {
                              prompt.steps = int.parse(value)
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(width: 60,
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            labelText: "scale",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: 1,
                          controller: scaleTextController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          onChanged: (value) async {
                            final repository = await PromptRepository.getInstance();
                            repository.update(() => {
                              prompt.scale = int.parse(value)
                            });
                          },
                        ),
                      ),
                    ]
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
        try {
          await saveImage(item);
        } catch(e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 3),
          ));
        }
        setState(() {});
      }
    }
  }

  Future<void> saveImage(String imagePath) async {
    String targetImgPath = await copyImageFile(imagePath);

    final prompt = Prompt(
      Uuid.v4(),
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
