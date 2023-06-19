import 'package:flutter/material.dart';

abstract class AppTheme{

  Color get primaryColor => Colors.orangeAccent;
  Color get backgroundColor => Colors.black;
  Color get textColor => Colors.white;
  Color get accentColor => Colors.red;



  static AppTheme of(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark ? DarkTheme() : LightTheme();


}

class LightTheme extends AppTheme {
  @override
  Color get primaryColor => Colors.blue;

  @override
  Color get accentColor => Colors.orangeAccent;
  @override
  Color get backgroundColor => Colors.white;
  @override
  Color get textColor => Colors.black;
  
}

class DarkTheme extends AppTheme{

  @override
  Color get primaryColor => const Color.fromARGB(255, 235, 0, 0);

  @override
  Color get accentColor => Colors.orangeAccent;
  @override
  Color get backgroundColor => const Color.fromARGB(255, 26, 26, 26);
  @override
  Color get textColor => Colors.white;


}
