import 'dart:io';

import 'package:ai_prompt_organizer/ai_prompt_organizer.dart';
import 'package:ai_prompt_organizer/domain/schema/prompt.dart';
import 'package:ai_prompt_organizer/page/full_screen_dialog_page.dart';
import 'package:ai_prompt_organizer/util/db_util.dart';
import 'package:flutter/material.dart';

Widget buildGalleryPromptList({
  required BuildContext context,
  required ScrollController scController,
  required List<Prompt> promptList, required TextEditingController promptSearchTextController,
  required Future<bool> Function() loadPromptFromDB}) {
  const double imageWidth = 280;
  const double imageHeight = 280;

  void scrollTo(int index) {
    final windowSize = MediaQuery.of(context).size;
    final xImageNum = (windowSize.width / (imageWidth + 4)).floor();
    final row = (index / xImageNum).floor(); //y列目
    final indexY = (imageHeight + 6) * row; //y軸の高さ

    scController.animateTo(
        indexY,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOutQuint
    );
  }

  return SingleChildScrollView(
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
                        width: imageWidth, height:imageHeight,
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
                                      onTap: () async {
                                        if (prompt.value.imageData?.imagePath != null) {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => FullScreenDialogPage(promptList: promptList, index: prompt.key),
                                              fullscreenDialog: true,
                                            ),
                                          );
                                          if (result != null) {
                                            final index = result[0];
                                            scrollTo(index);
                                          }
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
  );
}