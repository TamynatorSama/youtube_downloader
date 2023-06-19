import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtube_downloader/bloc/app_bloc.dart';

import 'package:youtube_downloader/pages/download/download.dart';
import 'package:youtube_downloader/pages/history/history.dart';
import 'package:youtube_downloader/pages/webview/webview.dart';
import 'package:youtube_downloader/utils/app_theme.dart';
import 'package:youtube_downloader/utils/download_overlay.dart';
// import 'package:google_fonts/google_fonts.dart';

class Router extends StatefulWidget {
  const Router({super.key});

  @override
  State<Router> createState() => _RouterState();
}

class _RouterState extends State<Router> {
  int pageindex = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: WillPopScope(
        onWillPop: ()async{
          if(context.read<AppBloc>().state.controller != null){
            context.read<AppBloc>().state.controller!.goBack();
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: AppTheme.of(context).backgroundColor,
          body: Column(
            children: [
              Expanded(
                  child: PageView(
                    onPageChanged: (value){
                      pageindex = value;
                    },
                    physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: const [WebViewPage(), DownloadPage(), Historypage()],
              )),
            
            ],
          
          ),
          floatingActionButton: SpeedDial(
            backgroundColor: AppTheme.of(context).accentColor,
            overlayColor: const Color.fromARGB(61, 0, 0, 0),
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                onTap: (){
                  setValue(0);
                },
                child: SvgPicture.string('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-6 h-6"><path d="M15.75 8.25a.75.75 0 01.75.75c0 1.12-.492 2.126-1.27 2.812a.75.75 0 11-.992-1.124A2.243 2.243 0 0015 9a.75.75 0 01.75-.75z" /><path fill-rule="evenodd" d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25zM4.575 15.6a8.25 8.25 0 009.348 4.425 1.966 1.966 0 00-1.84-1.275.983.983 0 01-.97-.822l-.073-.437c-.094-.565.25-1.11.8-1.267l.99-.282c.427-.123.783-.418.982-.816l.036-.073a1.453 1.453 0 012.328-.377L16.5 15h.628a2.25 2.25 0 011.983 1.186 8.25 8.25 0 00-6.345-12.4c.044.262.18.503.389.676l1.068.89c.442.369.535 1.01.216 1.49l-.51.766a2.25 2.25 0 01-1.161.886l-.143.048a1.107 1.107 0 00-.57 1.664c.369.555.169 1.307-.427 1.605L9 13.125l.423 1.059a.956.956 0 01-1.652.928l-.679-.906a1.125 1.125 0 00-1.906.172L4.575 15.6z" clip-rule="evenodd" /></svg>'),
              ),
              SpeedDialChild(
                onTap: ()async{
                  await showDownloadOverlay(context);
                  // setValue(1);
                  // if(context.read<AppBloc>().state.controller != null){
                  //   String? url = await context.read<AppBloc>().state.controller!.currentUrl();
                  // var link = await FlutterYoutubeDownloader.extractYoutubeLink(url!, 37);
                  // print(link);
                  // context.read<AppBloc>().state.controller!.goBack();
          // }
                },
                child: SvgPicture.string('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-6 h-6"><path fill-rule="evenodd" d="M10.5 3.75a6 6 0 00-5.98 6.496A5.25 5.25 0 006.75 20.25H18a4.5 4.5 0 002.206-8.423 3.75 3.75 0 00-4.133-4.303A6.001 6.001 0 0010.5 3.75zm2.25 6a.75.75 0 00-1.5 0v4.94l-1.72-1.72a.75.75 0 00-1.06 1.06l3 3a.75.75 0 001.06 0l3-3a.75.75 0 10-1.06-1.06l-1.72 1.72V9.75z" clip-rule="evenodd" /></svg>'),
              ),
              SpeedDialChild(
                 onTap: (){
                  setValue(1);
                },
                child: SvgPicture.string('<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="currentColor" d="M13.5 8H12v5l4.28 2.54l.72-1.21l-3.5-2.08V8M13 3a9 9 0 0 0-9 9H1l3.96 4.03L9 12H6a7 7 0 0 1 7-7a7 7 0 0 1 7 7a7 7 0 0 1-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42A8.896 8.896 0 0 0 13 21a9 9 0 0 0 9-9a9 9 0 0 0-9-9"/></svg>'),
              )
            ],
          ),
        ),
      ),
    );
  }
  void setValue(int value){
    pageindex = value;
                pageController.jumpToPage(value);
                setState(() {});
  }
}
