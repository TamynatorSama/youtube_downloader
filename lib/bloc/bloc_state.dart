import 'package:webview_flutter/webview_flutter.dart';

abstract class BlocState{
  late bool isDownloading;
  WebViewController? controller;

  BlocState({this.isDownloading = false,this.controller});
}

class RestAppState extends BlocState{
  WebViewController? controller;
  RestAppState({this.controller}):super(controller: controller);
}