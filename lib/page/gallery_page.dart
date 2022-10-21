import 'dart:io';

import 'package:flutter/material.dart';

import '../ai_prompt_organizer.dart';
import '../model/schema/prompt.dart';
import '../repository/prompt_repository.dart';
import '../util/db_util.dart';
import 'full_screen_dialog_page.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key, this.searchWord});

  final String? searchWord;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<Prompt> promptList = List.empty();
  final promptSearchTextController = TextEditingController();
  bool isInit = true;

  Future<bool> loadPromptFromDB() async {
    final repository = await PromptRepository.getInstance();

    repository.streamController.stream.listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        promptList = event.toList();
        isInit = false;
      });
    });

    if (isInit) {
      List<Prompt>? list = repository.getAllPrompts();
      if (widget.searchWord != null) {
        promptSearchTextController.text = widget.searchWord!;
        repository.showSearchedPrompts(widget.searchWord!.split(','));
      }

      if (list != null) {
        promptList = list;
        return true;
      }
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scController = ScrollController();

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, [null, promptSearchTextController.text]);
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Gallery Page"),
            actions: [
              IconButton(
                onPressed: () async {
                  if (promptList.isNotEmpty) {
                    scController.animateTo(
                        0,
                        duration: const Duration(seconds: 1), //移動するのに要する時間を設定
                        curve: Curves.easeOutQuint //アニメーションの種類を設定
                    );
                  }
                },
                icon: const Icon(Icons.arrow_upward),
              ),
              IconButton(
                onPressed: () async {
                  if (promptList.isNotEmpty) {
                    scController.animateTo(
                        scController.position.maxScrollExtent,
                        duration: const Duration(seconds: 1), //移動するのに要する時間を設定
                        curve: Curves.easeOutQuint //アニメーションの種類を設定
                    );
                  }
                },
                icon: const Icon(Icons.arrow_downward),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
                child: SizedBox(width: 200,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      labelText: "search",
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                    ),
                    maxLines: 1,
                    controller: promptSearchTextController,
                    onChanged: (value) async {
                      final searchWords = value.split(',');
                      final repository = await PromptRepository.getInstance();
                      repository.showSearchedPrompts(searchWords);
                    },
                  ),
                ),
              ),
            ],
          ),
          body: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top:8),
                child: SingleChildScrollView(
                  controller: scController,
                  child: FutureBuilder(
                    future: loadPromptFromDB(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!) {
                          if (promptList.isNotEmpty) {
                            return Wrap(
                              children: promptList.asMap().entries.map<Widget>((prompt) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 6, left: 4, right: 4),
                                  child: Container(
                                      width: 280, height:280,
                                      alignment: Alignment.center,
                                      child: FutureBuilder(
                                        future: DBUtil.getImageFullPath(prompt.value.imageData!.imagePath),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            if (!snapshot.hasError) {
                                              return Stack(
                                                alignment: Alignment.bottomRight,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (prompt.value.imageData?.imagePath != null) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) => FullScreenDialogPage(imagePath: prompt.value.imageData!.imagePath),
                                                            fullscreenDialog: true,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Image.file(File(snapshot.data!)),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context, [prompt.key, promptSearchTextController.text]);
                                                    },
                                                    icon: const Icon(Icons.arrow_right, color: Colors.grey)
                                                  )
                                                ],
                                              );
                                            } else {
                                              return Text("${ErrorMessage.someError}: ${snapshot.error}");
                                            }
                                          } else {
                                            return const Text(ErrorMessage.imageNotFound);
                                          }
                                        },
                                      )
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return const SizedBox(
                                width: 600,
                                height: 600,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(GuidanceMessage.galleryIsEmpty,
                                    style: TextStyle(color: Colors.grey, letterSpacing: 2),
                                  ),
                                )
                            );
                          }
                        } else {
                          return const Text(ErrorMessage.dbReadingError);
                        }
                      } else {
                        return const Text(StateMessage.dbReading);
                      }
                    }),
                  ),
                ),
              )
          )
      ),
    );
  }
}