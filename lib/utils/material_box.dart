import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:smooth_study/model/material_model.dart';
import 'package:smooth_study/utils/constants.dart';

class MaterialBox {
  static late Box materialBox;

  static Future initialize() async {
    materialBox = await Hive.openBox(materialCache);
  }

  static List<MaterialModel>? getMaterial(String materialKey) {
    if (!materialBox.containsKey(materialKey)) {
      return null;
    } else {
      var materialCacheList = materialBox.get(materialKey) as List;
      List<MaterialModel> json = materialCacheList
          .map((e) => MaterialModel.toJson(jsonDecode(e)))
          .toList();
      return json;
    }
  }
}
