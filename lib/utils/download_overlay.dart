import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_downloader/bloc/app_actions.dart';
import 'package:youtube_downloader/bloc/app_bloc.dart';
import 'package:youtube_downloader/utils/app_theme.dart';

Future<void> showDownloadOverlay(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: const DownloadLinkWidget())));
}

class DownloadLinkWidget extends StatefulWidget {
  const DownloadLinkWidget({super.key});

  @override
  State<DownloadLinkWidget> createState() => _DownloadLinkWidgetState();
}

class _DownloadLinkWidgetState extends State<DownloadLinkWidget> {
  List<String> format = [
    "m4a", "mp4",
    //  "3gp", "webm"
  ];
  var quality = [
    [
      {"value": "139", "resolution": "48k", "isAvailable": false},
      {"value": "140", "resolution": "128k", "isAvailable": true},
      {"value": "141", "resolution": "256k", "isAvailable": false},
    ],
    [
      {"value": "18", "resolution": "360p", "isAvailable": true},
      {"value": "22", "resolution": "720p", "isAvailable": true},
      {"value": "37", "resolution": "1080p", "isAvailable": false},
    ],
    // [
    //   {
    //     "value": "17",
    //     "resolution":"144p",
    //     "isAvailable": false
    //   },
    //   {
    //     "value": "36",
    //     "resolution":"180p",
    //     "isAvailable": false
    //   },
    // ],
    // [
    //   {
    //     "value": "100",
    //     "resolution":"360p",
    //     "isAvailable": false
    //   },
    //   {
    //     "value": "101",
    //     "resolution":"480p",
    //     "isAvailable": false
    //   },
    //   {
    //     "value": "102",
    //     "resolution":"720p",
    //     "isAvailable": false
    //   },
    // ]
  ];
  int selectedFormat = 0;
  int selectedQuality = 0;

  bool isDownloadingCurrent = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 350,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
      decoration: BoxDecoration(
          color: AppTheme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Format",
                  style: GoogleFonts.montserrat(
                      color: AppTheme.of(context).textColor,
                      fontWeight: FontWeight.w600)),
              Container(
                height: 55,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 7, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color.fromARGB(225, 181, 181, 181),
                      width: 1),
                ),
                child: SingleChildScrollView(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        format.length,
                        (index) => InkWell(
                              onTap: () {
                                setState(() {
                                  selectedFormat = index;
                                });
                              },
                              child: Container(
                                decoration: selectedFormat == index
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: AppTheme.of(context)
                                            .accentColor
                                            .withOpacity(0.2),
                                        border: Border.all(
                                            color: AppTheme.of(context)
                                                .accentColor,
                                            width: 1),
                                      )
                                    : null,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Text(
                                  format[index],
                                  style: GoogleFonts.montserrat(
                                      color: AppTheme.of(context).textColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )),
                  ),
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Quality",
                  style: GoogleFonts.montserrat(
                      color: AppTheme.of(context).textColor,
                      fontWeight: FontWeight.w600)),
              Padding(
                padding: const EdgeInsets.only(top: 7, bottom: 20),
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        quality[selectedFormat].length,
                        (index) => InkWell(
                              onTap: () {
                                setState(() {
                                  selectedQuality = index;
                                });
                              },
                              child: Container(
                                decoration: selectedQuality == index
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: AppTheme.of(context)
                                            .accentColor
                                            .withOpacity(0.2),
                                        border: Border.all(
                                            color: AppTheme.of(context)
                                                .accentColor,
                                            width: 1),
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: const Color.fromARGB(
                                            89, 181, 181, 181),
                                      ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 25),
                                child: Text(
                                  quality[selectedFormat][index]["resolution"]
                                      .toString(),
                                  style: GoogleFonts.montserrat(
                                      color: AppTheme.of(context).textColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(225, 181, 181, 181),
                              width: 2)),
                      hintText: "Paste Youtube link",
                      hintStyle: GoogleFonts.montserrat(
                          color: AppTheme.of(context).textColor)),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                alignment: Alignment.center,
                width: 100,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    color: AppTheme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Download",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.of(context).textColor),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              context.read<AppBloc>().add(DownloadVideo(quality[selectedFormat]
                      [selectedQuality]["value"]
                  .toString()));
            },
            child: Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  color: AppTheme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5)),
              child: isDownloadingCurrent
                  ? ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxHeight: 23, maxWidth: 23),
                      child: CircularProgressIndicator(
                          color: AppTheme.of(context).textColor),
                    )
                  : Text(
                      "Download current video",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.of(context).textColor),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
