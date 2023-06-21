import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smooth_study/model/material_model.dart';
import 'package:smooth_study/utils/download_notifier.dart';
import 'package:smooth_study/utils/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:internet_file/storage_io.dart';

class PdfViewPage extends StatefulWidget {
  final MaterialModel materialModel;
  const PdfViewPage({super.key, required this.materialModel});

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  Timer? _removeAppBar;
  bool hideAppBar = false;
  bool shouldHide = false;
  final storageIO = InternetFileStorageIO();

  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _removeAppBar = getTimer();
    super.initState();
  }

  getTimer() {
    return Timer(const Duration(seconds: 5), () {
      if (shouldHide) {
        setState(() {
          hideAppBar = true;
        });
      }
    });
  }

  downloadFile(String downloadLink) async {
    String? path =  await downloadNotifier.downloadMaterial(storageIO: storageIO,downloadLink: widget.materialModel.filePath,fileName: widget.materialModel.fileName);
    print(path);
    if( path !=null && path.isNotEmpty){
      widget.materialModel.filePath = path;
      widget.materialModel.isLocal = true;
    if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _removeAppBar!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.materialModel);
        return true;
      },
      child: Listener(
        onPointerDown: (event) {
          setState(() {
            hideAppBar = false;
          });
          if (_removeAppBar != null) {
            _removeAppBar!.cancel();
            _removeAppBar = getTimer();
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.maxFinite, 80),
            child: AnimatedContainer(
              height: hideAppBar ? 0 : 80,
              duration: const Duration(milliseconds: 300),
              child: ListenableBuilder(
                listenable: downloadNotifier,
                builder: (context,child) {
                  return AppBar(
                    title: Text(
                      widget.materialModel.fileName,
                      style: primaryTextStyle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    backgroundColor: const Color.fromARGB(255, 49, 49, 49),
                    leadingWidth: 40,
                    leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context, widget.materialModel);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 18,
                        )),
                    actions: [
                      downloadNotifier.downloads.containsKey(widget.materialModel.fileName) ? ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 20,maxHeight: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:18.0),
                          child: CircularProgressIndicator(
                            value: (downloadNotifier.downloads[widget.materialModel.fileName]["progress"]) / 100,
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )): IconButton(
                          onPressed: () {
                            // DownloadNotifier.downloads.any((element) => element.containsKey(widget.materialModel.fileName))''
                            if (!widget.materialModel.isLocal) {
                              downloadFile(widget.materialModel.filePath);
                            }
                          },
                          icon: Icon(
                            widget.materialModel.isLocal? Icons.check_circle_rounded :Icons.cloud_download_rounded,
                            size: 20,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                          )),
                    ],
                  );
                }
              ),
            ),
          ),
          body: widget.materialModel.isLocal
              ? SfPdfViewer.file(
                  File(widget.materialModel.filePath),
                  key: _pdfViewerKey,
                  controller: _pdfViewerController,
                  pageLayoutMode: PdfPageLayoutMode.continuous,
                  onDocumentLoaded: (details) {
                    shouldHide = true;
                    widget.materialModel.totalPages =
                        details.document.pages.count;
                    if (widget.materialModel.hasBeenModified == false) {
                      widget.materialModel.hasBeenModified = true;
                    }
                    _pdfViewerController.jumpToPage(
                        widget.materialModel.initialPage == 0
                            ? 1
                            : widget.materialModel.initialPage);
                  },
                  onPageChanged: (details) {
                    if (widget.materialModel.hasBeenModified == false) {
                      widget.materialModel.hasBeenModified = true;
                    }
                    widget.materialModel.initialPage = details.newPageNumber;
                  },
                )
              : SfPdfViewer.network(
                  widget.materialModel.filePath,
                  key: _pdfViewerKey,
                  controller: _pdfViewerController,
                  pageLayoutMode: PdfPageLayoutMode.continuous,
                  onDocumentLoadFailed: (failedDetails) async {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(failedDetails.description)));
                    Navigator.pop(context);
                  },
                  onDocumentLoaded: (details) {
                    shouldHide = true;
                    widget.materialModel.totalPages =
                        details.document.pages.count;
                    if (widget.materialModel.hasBeenModified == false) {
                      widget.materialModel.hasBeenModified = true;
                    }
                    _pdfViewerController.jumpToPage(
                        widget.materialModel.initialPage == 0
                            ? 1
                            : widget.materialModel.initialPage);
                  },
                  onPageChanged: (details) {
                    if (widget.materialModel.hasBeenModified == false) {
                      widget.materialModel.hasBeenModified = true;
                    }
                    widget.materialModel.initialPage = details.newPageNumber;
                  },
                ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xff6259FF),
              child: const Icon(Icons.bookmark),
              onPressed: () {
                _pdfViewerKey.currentState!.openBookmarkView();
              }),
        ),
      ),
    );
  }
}

