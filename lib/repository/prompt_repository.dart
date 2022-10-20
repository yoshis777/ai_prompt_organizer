import 'dart:async';
import 'dart:io';

import 'package:ai_prompt_organizer/ai_prompt_organizer.dart';
import 'package:realm/realm.dart';

import '../model/schema/prompt.dart';
import '../util/db_util.dart';

class PromptRepository {
  static PromptRepository? _instance;
  static const dbFileName = AIPromptOrganizer.dbFileName;

  Realm realm;
  var streamController = StreamController<RealmResults<Prompt>>.broadcast();

  PromptRepository(this.realm);

  static Future<PromptRepository> getInstance() async {
    if (_instance == null) {
      var dbDir = await DBUtil.getDatabaseFolder();

      var config = Configuration.local(
        [
          Prompt.schema,
          ImageData.schema,
        ],
        path: "${dbDir.path}/$dbFileName"
      );

      var realm = Realm(config);
      _instance = PromptRepository(realm);
    }

    return _instance!;
  }

  List<Prompt>? getAllPrompts() {
    if (realm.isClosed) {
      return null;
    }

    return realm.query<Prompt>("TRUEPREDICATE SORT(createdAt DESC)").toList();
  }

  RealmResults<Prompt> getAllResults() {
    return realm.query<Prompt>("TRUEPREDICATE SORT(createdAt DESC)");
  }

  void showSearchedPrompts(List<String> keywords) {
    if (realm.isClosed) {
      return;
    }
    RealmResults<Prompt> results = realm.query("TRUEPREDICATE SORT(createdAt DESC)");
    for (String keyword in keywords) {
      results = results.query(r'prompt CONTAINS $0 OR seed == $0 OR description CONTAINS $0', [keyword]);
    }
    streamController.sink.add(results);
  }

  void addPrompt(Prompt prompt) {
    if (realm.isClosed) {
      return;
    }

    realm.write(() {
      realm.add(prompt, update: true);
      //for rebuilding prompt widgets
      streamController.sink.add(getAllResults());
    });
  }

  void update(void Function() callback) {
    if (realm.isClosed) {
      return;
    }

    realm.write(() {
      callback();
    });
  }

  Future<void> deletePromptImageFile(Prompt prompt) async {
    if (prompt.imageData != null && prompt.imageData?.imagePath != null) {
      try {
        final deleteFile = File(await DBUtil.getImageFullPath(prompt.imageData!.imagePath));
        if (await deleteFile.exists()) {
          await deleteFile.delete();
        }
      } catch (e) {
        return Future.error(ErrorMessage.fileDeleteError);
      }
    }
  }

  Future<void> deletePrompt(Prompt prompt) async {
    if (realm.isClosed) {
      return;
    }

    realm.write(() {
      if (prompt.imageData != null) {
        realm.delete(prompt.imageData!);
      }
      realm.delete(prompt);
      streamController.sink.add(getAllResults());
    });
  }
}