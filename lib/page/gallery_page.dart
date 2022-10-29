import 'package:ai_prompt_organizer/component/build_gallary_prompt_list.dart';
import 'package:ai_prompt_organizer/domain/prompt.dart';
import 'package:flutter/material.dart';

import '../domain/schema/prompt.dart';
import '../repository/prompt_repository.dart';


class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key, this.searchWord});

  final String? searchWord;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<Prompt> promptList = List.empty();
  final promptSearchTextController = TextEditingController();
  late IPromptRepository repository;
  ScrollController scController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future(() async {
      repository = await IPromptRepository.getInstance();
      await getAllPrompts();
    });
  }

  Future<void> getAllPrompts() async {
    List<Prompt>? list = repository.getAllPrompts();
    if (widget.searchWord != null) {
      promptSearchTextController.text = widget.searchWord!;
      repository.showSearchedPrompts(widget.searchWord!.split(','));
    }
    if (list != null) {
      promptList = list;
    }
  }

  Future<bool> loadPromptFromDB() async {
    final repository = await PromptRepository.getInstance();

    repository.streamController.stream.listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        promptList = event.toList();
      });
    });

    return true;
  }

  Future<void> scrollToTop() async {
    if (promptList.isNotEmpty) {
      scController.animateTo(
        0,
        duration: const Duration(seconds: 1), //移動するのに要する時間を設定
        curve: Curves.easeOutQuint //アニメーションの種類を設定
      );
    }
  }

  Future<void> scrollToBottom() async {
    if (promptList.isNotEmpty) {
      scController.animateTo(
          scController.position.maxScrollExtent,
          duration: const Duration(seconds: 1), //移動するのに要する時間を設定
          curve: Curves.easeOutQuint //アニメーションの種類を設定
      );
    }
  }

  Future<void> showSearchedPrompts(value) async {
    final searchWords = value.split(',');
    repository.showSearchedPrompts(searchWords);
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: scrollToTop,
                icon: const Icon(Icons.arrow_upward),
              ),
              IconButton(
                onPressed: scrollToBottom,
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
                    onChanged: (value) => showSearchedPrompts(value),
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
                child: buildGalleryPromptList(
                  context: context,
                  scController: scController,
                  promptList: promptList,
                  promptSearchTextController: promptSearchTextController,
                  loadPromptFromDB: loadPromptFromDB)
              )
          )
      ),
    );
  }
}