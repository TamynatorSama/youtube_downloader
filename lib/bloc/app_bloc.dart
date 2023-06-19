import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_downloader/bloc/app_actions.dart';
import 'package:youtube_downloader/bloc/bloc_state.dart';
import 'package:youtube_downloader/utils/app_theme.dart';

class AppBloc extends Bloc<AppActions, BlocState> {
  AppBloc() : super(RestAppState()) {
    on<InitController>((event, emit) {
      if (state.controller != null) return;
      state.controller = state.controller ?? WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(AppTheme.of(event.context).backgroundColor)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse('https://www.youtube.com/'));
      emit(RestAppState(controller: state.controller));
    });
    on<DownloadVideo>((event, emit) async {
      if (state.controller != null) {
        String? url = await state.controller!.currentUrl();
        try {
          var link = await FlutterYoutubeDownloader.extractYoutubeLink(
              url!, int.tryParse(event.value) ?? 18);
              print(link);
          if (link != null) {
            var test = await FlutterYoutubeDownloader.downloadVideo(await state.controller!.currentUrl()??"", "sadsa", int.tryParse(event.value) ?? 18);
            print(test);
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }
}
