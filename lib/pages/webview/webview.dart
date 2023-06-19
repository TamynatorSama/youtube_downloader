import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_downloader/bloc/app_actions.dart';
import 'package:youtube_downloader/bloc/app_bloc.dart';
import 'package:youtube_downloader/bloc/bloc_state.dart';
import 'package:youtube_downloader/utils/app_theme.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  @override
  void initState() {
    context.read<AppBloc>().add(InitController(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: AppTheme.of(context).backgroundColor,
      duration: const Duration(milliseconds: 200),
      child: BlocConsumer<AppBloc,BlocState>(
        listener: (context, state){},
        builder: (context,state) {
          if(state.controller == null){
            return Container(
              color: AppTheme.of(context).backgroundColor,
            );
          }
           return WebViewWidget(
            controller: state.controller!,
          );
        }
      ),
    );
  }
}
