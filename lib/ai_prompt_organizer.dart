class AIPromptOrganizer {
  static const dbFileName = "organizer_db.realm";
  static const baseDBFolderName = "organizer_db";
  static const imageFolderName = "images";
}

enum PromptColumn {
  prompt,
  seed,
  uc,
  description
}

class GuidanceMessage {
  static const promptListIsEmpty = "以下のいずれかの方法でリストを追加することができます。\n"
      "・右下のボタンから画像ファイルを選択\n"
      "・この画面へ画像ファイルをドラッグ&ドロップ";
}

class ErrorMessage {
  static const someError = "エラーが発生しました。";
  static const fileExists = "既に同名のファイルが登録されています。";
  static const imageNotFound = "対象の画像が存在しません。";
  static const dbReadingError = "管理DBの読み込み中にエラーが発生しました。";
  static const fileDeleteError = "ファイルを削除できませんでした。";
}

class StateMessage {
  static const dbReading = "管理DBを読み込んでいます。";
  static const imageReading = "画像を読み込んでいます。";
}

class DeleteAlertMessage {
  static const title = "このデータを削除しますか？";
  static const content = "削除したデータは元に戻せません";
}