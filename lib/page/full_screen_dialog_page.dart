import 'dart:io';

import 'package:ai_prompt_organizer/component/scroll_detector.dart';
import 'package:ai_prompt_organizer/domain/schema/prompt.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../ai_prompt_organizer.dart';
import '../util/db_util.dart';

class FullScreenDialogPage extends StatefulWidget {
  const FullScreenDialogPage({super.key, required this.promptList, required this.index});

  final List<Prompt> promptList;
  final int index;

  @override
  State<FullScreenDialogPage> createState() => _FullScreenDialogPageState();
}

class _FullScreenDialogPageState extends State<FullScreenDialogPage> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  void decrement() {
    index--;
    if (index < 0) {
      index = widget.promptList.length - 1;
    }
  }

  void increment() {
    index++;
    if (index > widget.promptList.length - 1) {
      index = 0;
    }
  }

  void scrollIncrement(PointerScrollEvent event) {
    setState(() {
      if (event.scrollDelta.dy < 0) { decrement(); }
      else if (event.scrollDelta.dy > 0) { increment(); }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              const SizedBox(width: 15),
              IconButton(
                  onPressed: () {
                    setState(() {
                      decrement();
                    });
                  },
                  icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.grey)
              ),
              Expanded(
                child: ScrollDetector(onPointerScroll: scrollIncrement,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, [index]);
                    },
                    child: buildImageData(index),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      increment();
                    });
                  },
                  icon: const Icon(Icons.arrow_circle_right_outlined, color: Colors.grey)
              ),
              const SizedBox(width: 15),
            ]
        ),
      ),
    );
  }

  Widget buildImageData(int index) {
    return FutureBuilder(
      future: DBUtil.getImageFullPath(widget.promptList[index].imageData!.imagePath),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (!snapshot.hasError) {
            return Image.file(File(snapshot.data!));
          } else {
            return Text("${ErrorMessage.someError}: ${snapshot.error}");
          }
        } else {
          return const Text(ErrorMessage.imageNotFound);
        }
      },
    );
  }
}
