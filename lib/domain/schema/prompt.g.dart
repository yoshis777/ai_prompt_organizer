// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Prompt extends _Prompt with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  Prompt(
    Uuid id,
    DateTime createdAt,
    DateTime updatedAt, {
    ImageData? imageData,
    String prompt = "",
    String diffusionType = "",
    int sizeX = 512,
    int sizeY = 768,
    String ucType = "",
    String uc = "",
    bool addQualityTags = true,
    int steps = 28,
    int scale = 11,
    String seed = "",
    String advancedSampling = "k_euler_ancestral",
    String description = "",
    ImageData? sourceImageData,
    double? strength,
    double? noise,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<Prompt>({
        'prompt': "",
        'diffusionType': "",
        'sizeX': 512,
        'sizeY': 768,
        'ucType': "",
        'uc': "",
        'addQualityTags': true,
        'steps': 28,
        'scale': 11,
        'seed': "",
        'advancedSampling': "k_euler_ancestral",
        'description': "",
      });
    }
    RealmObject.set(this, 'id', id);
    RealmObject.set(this, 'imageData', imageData);
    RealmObject.set(this, 'prompt', prompt);
    RealmObject.set(this, 'diffusionType', diffusionType);
    RealmObject.set(this, 'sizeX', sizeX);
    RealmObject.set(this, 'sizeY', sizeY);
    RealmObject.set(this, 'ucType', ucType);
    RealmObject.set(this, 'uc', uc);
    RealmObject.set(this, 'addQualityTags', addQualityTags);
    RealmObject.set(this, 'steps', steps);
    RealmObject.set(this, 'scale', scale);
    RealmObject.set(this, 'seed', seed);
    RealmObject.set(this, 'advancedSampling', advancedSampling);
    RealmObject.set(this, 'description', description);
    RealmObject.set(this, 'sourceImageData', sourceImageData);
    RealmObject.set(this, 'strength', strength);
    RealmObject.set(this, 'noise', noise);
    RealmObject.set(this, 'createdAt', createdAt);
    RealmObject.set(this, 'updatedAt', updatedAt);
  }

  Prompt._();

  @override
  Uuid get id => RealmObject.get<Uuid>(this, 'id') as Uuid;
  @override
  set id(Uuid value) => RealmObject.set(this, 'id', value);

  @override
  ImageData? get imageData =>
      RealmObject.get<ImageData>(this, 'imageData') as ImageData?;
  @override
  set imageData(covariant ImageData? value) =>
      RealmObject.set(this, 'imageData', value);

  @override
  String get prompt => RealmObject.get<String>(this, 'prompt') as String;
  @override
  set prompt(String value) => RealmObject.set(this, 'prompt', value);

  @override
  String get diffusionType =>
      RealmObject.get<String>(this, 'diffusionType') as String;
  @override
  set diffusionType(String value) =>
      RealmObject.set(this, 'diffusionType', value);

  @override
  int get sizeX => RealmObject.get<int>(this, 'sizeX') as int;
  @override
  set sizeX(int value) => RealmObject.set(this, 'sizeX', value);

  @override
  int get sizeY => RealmObject.get<int>(this, 'sizeY') as int;
  @override
  set sizeY(int value) => RealmObject.set(this, 'sizeY', value);

  @override
  String get ucType => RealmObject.get<String>(this, 'ucType') as String;
  @override
  set ucType(String value) => RealmObject.set(this, 'ucType', value);

  @override
  String get uc => RealmObject.get<String>(this, 'uc') as String;
  @override
  set uc(String value) => RealmObject.set(this, 'uc', value);

  @override
  bool get addQualityTags =>
      RealmObject.get<bool>(this, 'addQualityTags') as bool;
  @override
  set addQualityTags(bool value) =>
      RealmObject.set(this, 'addQualityTags', value);

  @override
  int get steps => RealmObject.get<int>(this, 'steps') as int;
  @override
  set steps(int value) => RealmObject.set(this, 'steps', value);

  @override
  int get scale => RealmObject.get<int>(this, 'scale') as int;
  @override
  set scale(int value) => RealmObject.set(this, 'scale', value);

  @override
  String get seed => RealmObject.get<String>(this, 'seed') as String;
  @override
  set seed(String value) => RealmObject.set(this, 'seed', value);

  @override
  String get advancedSampling =>
      RealmObject.get<String>(this, 'advancedSampling') as String;
  @override
  set advancedSampling(String value) =>
      RealmObject.set(this, 'advancedSampling', value);

  @override
  String get description =>
      RealmObject.get<String>(this, 'description') as String;
  @override
  set description(String value) => RealmObject.set(this, 'description', value);

  @override
  ImageData? get sourceImageData =>
      RealmObject.get<ImageData>(this, 'sourceImageData') as ImageData?;
  @override
  set sourceImageData(covariant ImageData? value) =>
      RealmObject.set(this, 'sourceImageData', value);

  @override
  double? get strength => RealmObject.get<double>(this, 'strength') as double?;
  @override
  set strength(double? value) => RealmObject.set(this, 'strength', value);

  @override
  double? get noise => RealmObject.get<double>(this, 'noise') as double?;
  @override
  set noise(double? value) => RealmObject.set(this, 'noise', value);

  @override
  DateTime get createdAt =>
      RealmObject.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) => RealmObject.set(this, 'createdAt', value);

  @override
  DateTime get updatedAt =>
      RealmObject.get<DateTime>(this, 'updatedAt') as DateTime;
  @override
  set updatedAt(DateTime value) => RealmObject.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<Prompt>> get changes =>
      RealmObject.getChanges<Prompt>(this);

  @override
  Prompt freeze() => RealmObject.freezeObject<Prompt>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Prompt._);
    return const SchemaObject(Prompt, 'Prompt', [
      SchemaProperty('id', RealmPropertyType.uuid, primaryKey: true),
      SchemaProperty('imageData', RealmPropertyType.object,
          optional: true, linkTarget: 'ImageData'),
      SchemaProperty('prompt', RealmPropertyType.string),
      SchemaProperty('diffusionType', RealmPropertyType.string),
      SchemaProperty('sizeX', RealmPropertyType.int),
      SchemaProperty('sizeY', RealmPropertyType.int),
      SchemaProperty('ucType', RealmPropertyType.string),
      SchemaProperty('uc', RealmPropertyType.string),
      SchemaProperty('addQualityTags', RealmPropertyType.bool),
      SchemaProperty('steps', RealmPropertyType.int),
      SchemaProperty('scale', RealmPropertyType.int),
      SchemaProperty('seed', RealmPropertyType.string),
      SchemaProperty('advancedSampling', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('sourceImageData', RealmPropertyType.object,
          optional: true, linkTarget: 'ImageData'),
      SchemaProperty('strength', RealmPropertyType.double, optional: true),
      SchemaProperty('noise', RealmPropertyType.double, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp),
    ]);
  }
}

class ImageData extends _ImageData with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  ImageData(
    Uuid id,
    String imagePath, {
    String type = "output",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<ImageData>({
        'type': "output",
      });
    }
    RealmObject.set(this, 'id', id);
    RealmObject.set(this, 'imagePath', imagePath);
    RealmObject.set(this, 'type', type);
  }

  ImageData._();

  @override
  Uuid get id => RealmObject.get<Uuid>(this, 'id') as Uuid;
  @override
  set id(Uuid value) => RealmObject.set(this, 'id', value);

  @override
  String get imagePath => RealmObject.get<String>(this, 'imagePath') as String;
  @override
  set imagePath(String value) => RealmObject.set(this, 'imagePath', value);

  @override
  String get type => RealmObject.get<String>(this, 'type') as String;
  @override
  set type(String value) => RealmObject.set(this, 'type', value);

  @override
  Stream<RealmObjectChanges<ImageData>> get changes =>
      RealmObject.getChanges<ImageData>(this);

  @override
  ImageData freeze() => RealmObject.freezeObject<ImageData>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(ImageData._);
    return const SchemaObject(ImageData, 'ImageData', [
      SchemaProperty('id', RealmPropertyType.uuid, primaryKey: true),
      SchemaProperty('imagePath', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
    ]);
  }
}
