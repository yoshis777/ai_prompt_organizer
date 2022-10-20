import 'package:flutter/material.dart';

Widget aiOptionDropDown({required List<String> enumValues, required String nowValue, required void Function(String?) onChanged}) {
  return DropdownButton(
    value: nowValue,
    items: enumValues.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem(
        value: value,
        child: Text(value),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

enum DiffusionType {
  naiDiffusionAnimeCurated("NAI Diffusion Anime (Curated)"),
  naiDiffusionAnimeFull("NAI Diffusion Anime (Full)"),
  naiDiffusionFurry("NAI Diffusion Furry (BETA)");

  final String value;

  const DiffusionType(this.value);
}

Widget diffusionTypeDropDown({required String nowValue, required void Function(String?) onChanged}) {
  List<String> enumValues = DiffusionType.values.map((value) {return value.value;}).toList();
  nowValue = nowValue == "" ? enumValues.first : nowValue;

  return aiOptionDropDown(enumValues: enumValues, nowValue: nowValue, onChanged: onChanged);
}

enum UcType {
  lowQualityPlusBadAnatomy("Low Quality + Bad Anatomy"),
  lowQuality("Low Quality"),
  none("None");

  final String value;

  const UcType(this.value);
}

Widget ucTypeDropDown({required String nowValue, required void Function(String?) onChanged}) {
  List<String> enumValues = UcType.values.map((value) {return value.value;}).toList();
  nowValue = nowValue == "" ? enumValues.first : nowValue;

  return aiOptionDropDown(enumValues: enumValues, nowValue: nowValue, onChanged: onChanged);
}

enum AdvancedSamplingType {
  kEulerAncestral("k_euler_ancestral"),
  kEuler("k_euler"),
  kLms("k_lms"),
  plms("plms"),
  ddim("ddim");

  final String value;

  const AdvancedSamplingType(this.value);
}

Widget advancedSamplingDropDown({required String nowValue, required void Function(String?) onChanged}) {
  List<String> enumValues = AdvancedSamplingType.values.map((value) {return value.value;}).toList();
  nowValue = nowValue == "" ? enumValues.first : nowValue;

  return aiOptionDropDown(enumValues: enumValues, nowValue: nowValue, onChanged: onChanged);
}

