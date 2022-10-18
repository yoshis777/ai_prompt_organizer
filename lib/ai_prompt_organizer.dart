class AIPromptOrganizer {
  static const dbFileName = "organizer_db.realm";
  static const baseDBFolderName = "organizer_db";
  static const imageFolderName = "images";
}

class ErrorMessage {
  static const someError = "エラーが発生しました。";
  static const fileExists = "既に同名のファイルが登録されています。";
  static const imageNotFound = "対象の画像が存在しません。";
  static const dbReadingError = "管理DBの読み込み中にエラーが発生しました。";
}

class StateMessage {
  static const dbReading = "管理DBを読み込んでいます。";
  static const imageReading = "画像を読み込んでいます。";
}
