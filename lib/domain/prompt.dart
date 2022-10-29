import 'package:ai_prompt_organizer/ai_prompt_organizer.dart';
import 'package:ai_prompt_organizer/util/db_util.dart';
import 'package:realm/realm.dart';

import '../model/schema/prompt.dart';
import '../repository/prompt_repository.dart';

abstract class IPromptRepository {
  static PromptRepository? _instance;
  static const dbFileName = AIPromptOrganizer.dbFileName;

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
  List<Prompt>? getAllPrompts();
  RealmResults<Prompt> getAllResults();
  void showSearchedPrompts(List<String> keywords);
  void addPrompt(Prompt prompt);
  void update(void Function() callback);
  Future<void> deletePromptImageFile(Prompt prompt);
  Future<void> deletePrompt(Prompt prompt);

}