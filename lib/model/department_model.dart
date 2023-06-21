class SmoothStudyModel {
  late List<DepartmentModel> departments;

  SmoothStudyModel({required this.departments});

  SmoothStudyModel.fromJson(Map<String, dynamic> json) {
    departments = (json["department"] as List)
        .map((value) => DepartmentModel.fromJson(value))
        .toList();
  }

  Map<String,dynamic> toJson()=>{
    "department":departments.map((e) => e.toJson()).toList()
  };

}

class DepartmentModel {
  late String departmentName;
  late List<Level> levels;

  DepartmentModel({required this.departmentName, required this.levels});

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    departmentName = json["department_name"];
    levels = (json["levels"] as List).map((e) => Level.fromJson(e)).toList();
  }

  Map<String,dynamic> toJson()=>{
    "department_name":departmentName,
    "levels": levels.map((e) => e.toJson()).toList()
  };

}

class Level {
  late String levelName;
  late List<Courses> courses;

  Level({required this.courses, required this.levelName});

  Level.fromJson(Map<String, dynamic> json) {
    levelName = json["level_name"];
    courses = (json["courses"] as List)
        .map((element) => Courses.fromJson(element))
        .toList();
  }

  Map<String,dynamic> toJson()=>{
    "level_name":levelName,
    "courses": courses.map((e) => e.toJson()).toList()
  };

}

class Courses {
  late String courseCode;
  late String courseTitle;
  late String materialFolder;


  Courses({required this.courseCode,required this.courseTitle,required this.materialFolder});

  Courses.fromJson(Map<String, dynamic> json) {
    courseCode = json["course_code"];
    courseTitle = json["course_title"];
    materialFolder = json["material_folder"];
  }

  Map<String,dynamic> toJson()=>{
   "course_code":courseCode,
   "course_title":courseTitle,
   "material_folder": materialFolder
  };

}
