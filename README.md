# AI Prompt Organizer

NovelAIに入力するprompt情報を管理するためのアプリケーションソフトです。Windows用。使用は自己責任でお願いします。
拙いものですがソースコードは置いておきますので、Flutterに詳しい方は改変をご自由にどうぞです。

## Usage


### その他仕様
* 画像追加時
  * 同名のファイルは省く
  * リストの一番上のUndesiredContent等の項目を引き継ぐ
* 検索対象
  * prompt, descriptionは部分一致検索
  * seedは全一致検索
  * キーワードをコンマで区切るとAND検索(1girl, anime)