import 'package:realm/realm.dart';  // import realm package

part 'prompt.g.dart'; // declare a part file.

@RealmModel() // define a data model class
class _Prompt {
  @PrimaryKey()
  late Uuid id;
  late _ImageData? imageData;
  late String prompt;
  late String diffusionType;
  int sizeX = 512;
  int sizeY = 768;
  late String ucType;
  late String uc;
  bool addQualityTags = true;
  int steps = 28;
  int scale = 11;
  late String? seed;
  String advancedSampling = "k_euler_ancestral";

  late DateTime createdAt;
  late DateTime updatedAt;
}

/// 画像データのモデル
@RealmModel()
class _ImageData {
  @PrimaryKey()
  late Uuid id;
  late String imagePath;
}
