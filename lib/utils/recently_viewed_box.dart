import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:smooth_study/model/material_model.dart';
import 'package:smooth_study/utils/constants.dart';

class RecentViewedBox {
  static late Box recentBox;
  static List<MaterialModel> recentlyViewed = [];

  static Future initialize() async {
    recentBox = await Hive.openBox(resentlyViewed);
    if(!recentBox.containsKey(recentKey)) return;
    var recentlyViewedList = recentBox.get(recentKey) as List;
      List<MaterialModel> json = recentlyViewedList
          .map((e) => MaterialModel.toJson(jsonDecode(e)))
          .toList();
    recentlyViewed = json;

  }

  static void addToList(MaterialModel newMaterial){
     if(recentlyViewed.any((element) => element.fileName == newMaterial.fileName)){
        recentlyViewed.removeWhere((element) => element.fileName == newMaterial.fileName);
     }
     recentlyViewed = [newMaterial,...recentlyViewed];
     recentBox.put(recentKey, recentlyViewed.map((e) => jsonEncode(e.toJson())).toList());
  }
}
