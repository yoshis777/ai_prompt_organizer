import 'dart:async';
import 'dart:io';

import 'package:ai_prompt_organizer/ai_prompt_organizer.dart';
import 'package:path/path.dart';
import 'package:realm/realm.dart';

import '../domain/prompt.dart';
import '../model/schema/prompt.dart';
import '../util/db_util.dart';

class PromptRepository implements IPromptRepository {
  Realm realm;
  @override
  var streamController = StreamController<RealmResults<Prompt>>.broadcast();

  PromptRepository(this.realm);

  static Future<IPromptRepository> getInstance() async {
    return IPromptRepository.getInstance();
  }

  @override
  List<Prompt>? getAllPrompts() {
    if (realm.isClosed) {
      return null;
    }
    return realm.query<Prompt>("TRUEPREDICATE SORT(createdAt DESC)").toList();
  }

  @override
  RealmResults<Prompt> getAllResults() {
    return realm.query<Prompt>("TRUEPREDICATE SORT(createdAt DESC)");
  }

  @override
  void showSearchedPrompts(List<String> keywords) {
    if (realm.isClosed) {
      return;
    }
    RealmResults<Prompt> results = realm.query("TRUEPREDICATE SORT(createdAt DESC)");
    for (String keyword in keywords) {
      results = results.query(r'prompt CONTAINS $0 OR seed == $0 OR description CONTAINS $0 SORT(createdAt DESC)', [keyword]);
    }
    streamController.sink.add(results);
  }

  @override
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

  @override
  void update(void Function() callback) {
    if (realm.isClosed) {
      return;
    }

    realm.write(() {
      callback();
    });
  }

  @override
  Future<void> deletePromptImageFile(Prompt prompt) async {
    if (prompt.imageData?.imagePath != null) {
      final deleteFile = File(await DBUtil.getImageFullPath(prompt.imageData!.imagePath));
      try {
        if (await deleteFile.exists()) {
          await deleteFile.delete();
        }
      } catch (e) {
        return Future.error(ErrorMessage.fileDeleteError + basename(deleteFile.path));
      }
    }
  }

  @override
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