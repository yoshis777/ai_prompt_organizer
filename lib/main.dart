import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_prompt_organizer/page/home_page.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    setWindowTitle('AI Prompt Organizer');
    setWindowMinSize(const Size(1000, 600));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Prompt Organizer',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF0000cd),
      ),
      home: const MyHomePage(title: 'AI Prompt Organizer'),
    );
  }
}
