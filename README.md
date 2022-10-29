# AI Prompt Organizer

NovelAIに入力するprompt情報を管理するためのアプリケーションソフトです。Windows用。  
使用は自己責任でお願いします。[ソフトウェア本体のDLはコチラから。](https://github.com/yoshis777/ai_prompt_organizer/releases/latest/)  
拙いものですがソースコードは置いておきますので、Flutterに詳しい方は改変をご自由にどうぞです。

![ai_org](https://user-images.githubusercontent.com/32704339/197323944-ad38d9cb-215b-45c6-9245-468413506d2b.JPG)

## Usage
できること一覧です。

#### 画像追加 / 基本操作
<img src="https://user-images.githubusercontent.com/32704339/197325679-10287c0a-fff3-41fd-a2fe-fec207dc4b41.jpg" width="45%"><img src="https://user-images.githubusercontent.com/32704339/197325885-b50b312b-6a32-4c6e-9d49-75072e4644a2.jpg" width="45%">

#### 画像全体の表示
<img src="https://user-images.githubusercontent.com/32704339/197326032-7aca1322-5f2b-474d-87e0-3b61490b6c5d.jpg" width="45%"><img src="https://user-images.githubusercontent.com/32704339/197326052-3139eea4-1a1e-4192-b5a2-5f07e54b35ef.JPG" width="40%">

#### 画像一覧（ギャラリーページ）の表示
<img src="https://user-images.githubusercontent.com/32704339/197324813-2b8613e3-7762-45b0-a547-95d4bf24a8a2.jpg" width="45%"><img src="https://user-images.githubusercontent.com/32704339/197324843-8997e2d9-1d6b-41fa-bcf0-a4e7459fae4c.JPG" width="40%">

#### プロンプト情報の検索
<img src="https://user-images.githubusercontent.com/32704339/197324541-7290f3af-dd44-4808-91c4-2a66313f4c72.jpg" width="45%"><img src="https://user-images.githubusercontent.com/32704339/197324655-d65e4ac3-72c2-433e-99f2-6083064fd2d9.jpg" width="40%">

#### 指定したプロンプト情報へ移動
<img src="https://user-images.githubusercontent.com/32704339/197326315-86f88e64-9766-4713-aa2e-572abda671f0.jpg" width="45%"><img src="https://user-images.githubusercontent.com/32704339/197326210-a75911b4-d333-426e-9a5d-8aab41188ec4.JPG" width="40%">

### その他仕様
* 画像追加時
  * 複数のファイルを選択し、一括で追加可能
  * 同名のファイルは省く
  * リストの一番上のUndesiredContent等の項目を引き継ぐ
* 検索対象
  * prompt, descriptionは部分一致検索
  * seedは全一致検索
  * キーワードをコンマで区切るとAND検索(1girl, anime)
  
## 更新履歴
### v1.1（2022/10/30）
* 画像１枚表示画面で、以下で前後の画像に移動できるように（windowsフォトアプリの操作感）
  * 進むボタン戻るボタンを押下する
  * マウスホイールを前後する
* 検索ボックスにテキスト削除ボタンを追加
* seedは数字入力のみ許可するように対応
