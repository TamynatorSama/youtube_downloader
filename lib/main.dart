import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_downloader/bloc/app_bloc.dart';
import 'package:youtube_downloader/router.dart' as route;
// import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: const route.Router(),
                ),
        )
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key,});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late WebViewController controller;

//   @override
//   void initState() {
//     controller = WebViewController()
//   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   ..setBackgroundColor(const Color(0x00000000))
//   ..setNavigationDelegate(
//     NavigationDelegate(
//       onProgress: (int progress) {
//         // Update loading bar.
//       },
//       onPageStarted: (String url) {},
//       onPageFinished: (String url) {},
//       onWebResourceError: (WebResourceError error) {},
//       // onNavigationRequest: (NavigationRequest request) {
//       //   if (request.url.startsWith('https://www.youtube.com/')) {
//       //     return NavigationDecision.prevent;
//       //   }
//       //   return NavigationDecision.navigate;
//       // },
//     ),
//   )
//   ..loadRequest(Uri.parse('https://www.youtube.com/'));
//     super.initState();
//   }


//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.black : Colors.white,
//       resizeToAvoidBottomInset: false,
//       body: Padding(
//         padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top,bottom: MediaQuery.of(context).padding.bottom),
//         child: WebViewWidget(controller: controller),
//       )
//     );
//   }
// }
