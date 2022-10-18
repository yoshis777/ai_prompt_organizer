import 'dart:async';

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

  void addPrompt(Prompt prompt) {
    if (realm.isClosed) {
      return;
    }

    realm.write(() {
      realm.add(prompt, update: true);
      //for rebuilding prompt widgets
      streamController.sink.add(realm.all<Prompt>());
    });
  }
}