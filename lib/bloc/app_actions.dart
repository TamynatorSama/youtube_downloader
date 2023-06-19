import 'package:flutter/material.dart';

abstract class AppActions{
 const AppActions();
}

class InitController extends AppActions {
  final BuildContext context;
  const InitController(this.context);
}

class DownloadVideo extends AppActions {
  final String value;
  const DownloadVideo(this.value);
}
