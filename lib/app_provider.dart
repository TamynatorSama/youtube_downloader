import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_study/model/department_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smooth_study/model/material_model.dart';
import 'package:smooth_study/utils/constants.dart';
import 'package:smooth_study/utils/material_box.dart';

class AppProvider extends ChangeNotifier {
  SmoothStudyModel? model;

  bool error = false;

  Future<void> getListOfCourses() async {
    FirebaseFirestore cloudFireStore = FirebaseFirestore.instance;
    final ref = cloudFireStore.collection(collectionName);
    try {
      if(error){
        error = false;
        notifyListeners();
      }
      final docs = await ref.get();
      model = SmoothStudyModel.fromJson(docs.docs.first.data());
    } on FirebaseException {
      if (model == null) {
        error = true;
        notifyListeners();
      }
    } catch (e) {
      if (model == null) {
        error = true;
        notifyListeners();
      }
    }
  }

  Future<Map<String, dynamic>> getMaterials(String materialPath) async {

    List<MaterialModel> coursesMaterial = [];
    List<MaterialModel>? cachedMaterials =
        MaterialBox.getMaterial(materialPath);

    Reference materialRef =
        FirebaseStorage.instance.ref().child("/$materialPath");

    try {
      var materials = await materialRef.listAll();
      if (materials.items.isNotEmpty) {
        for (var material in materials.items) {
          coursesMaterial.add(MaterialModel(
              fileName: material.name,
              filePath: await material.getDownloadURL(),
              isLocal: false));
        }

        if (cachedMaterials != null) {
          if (cachedMaterials.isEqual(coursesMaterial)) {
            return {
              "status": true,
              "message": "database sync successful",
              "data": coursesMaterial
            };
          } else {
            var downloadedMaterials =
                cachedMaterials.where((element) => element.hasBeenModified).toList();

            List<MaterialModel> newCourseMaterial = coursesMaterial.map((e) {
              if (downloadedMaterials
                  .where((element) => element.fileName == e.fileName)
                  .isNotEmpty) {
                return downloadedMaterials
                    .where((element) => element.fileName == e.fileName)
                    .first;
              }
              return e;
            }).toList();

            MaterialBox.materialBox.put(materialPath,
                newCourseMaterial.map((e) => jsonEncode(e.toJson())).toList());
            return {
              "status": true,
              "message": "database sync successful",
              "data": newCourseMaterial
            };
          }
        }
        MaterialBox.materialBox
            .put(materialPath, coursesMaterial.map((e) => jsonEncode(e.toJson())).toList());

        return {
          "status": true,
          "message": "database sync successful",
          "data": coursesMaterial
        };
      } else {
        return {
          "status": true,
          "message": "database sync successful",
          "data": [...coursesMaterial, ...cachedMaterials ?? []]
        };
      }
    } on FirebaseException {
      return {
        "status": false,
        "message": "unable to connect with database",
        "data": cachedMaterials
      };
    } catch (e) {
      return {
        "status": false,
        "message": e.toString(),
        "data": cachedMaterials
      };
    }
  }

}

extension on List {
  bool isEqual(List other) {
    if (other.length == length) {
      if (other.contains(first)) return true;
    }
    return false;
  }
}
