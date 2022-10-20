import 'dart:io';

import 'package:flutter/material.dart';

import '../ai_prompt_organizer.dart';
import '../util/db_util.dart';

class FullScreenDialogPage extends StatefulWidget {
  const FullScreenDialogPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<FullScreenDialogPage> createState() => _FullScreenDialogPageState();
}

class _FullScreenDialogPageState extends State<FullScreenDialogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: FutureBuilder(
            future: DBUtil.getImageFullPath(widget.imagePath),
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
          ),
        ),
      )
    );
  }
}