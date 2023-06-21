import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smooth_study/app_provider.dart';
import 'package:smooth_study/model/department_model.dart';
import 'package:smooth_study/model/material_model.dart';
import 'package:smooth_study/screens/pdf_view_page.dart';
import 'package:smooth_study/utils/material_box.dart';
import 'package:smooth_study/utils/recently_viewed_box.dart';
import 'package:smooth_study/utils/theme.dart';

class CourseMaterialListing extends StatefulWidget {
  final Courses course;
  final String levelName;
  const CourseMaterialListing(
      {super.key, required this.course, required this.levelName});

  @override
  State<CourseMaterialListing> createState() => _CourseMaterialListingState();
}

class _CourseMaterialListingState extends State<CourseMaterialListing> {
  bool isLoading = false;
  late List<MaterialModel> materials;

  late AppProvider provider;

  @override
  void initState() {
    setState(() {
      materials = MaterialBox.getMaterial(widget.course.materialFolder) ?? [];
    });
    provider = Provider.of<AppProvider>(context, listen: false);
    getMaterials();
    super.initState();
  }

  getMaterials() async {
    if (materials.isEmpty) {
      setState(() {
        isLoading = true;
      });
    }
    var response = await provider.getMaterials(widget.course.materialFolder);
    if (kDebugMode) print(response);
    if (response["status"]) {
      materials = response["data"];
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
          ? Center(
                      child: SizedBox(
                      height: 0.15 * size.width,
                      width: 0.15 * size.width,
                      child: SpinKitChasingDots(
                        itemBuilder: (context, index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index % 2 == 0
                                  ? const Color.fromARGB(255, 233, 119, 149)
                                  : const Color(0xff6259FF),
                            ),
                          );
                        },
                      ),
                    ),
                    )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).padding.top,
                      horizontal: 24),
                  width: double.maxFinite,
                  height: 250,
                  decoration: const BoxDecoration(
                      color: Color(0xff383838),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)),
                      image: DecorationImage(
                          alignment: Alignment.centerRight,
                          image: AssetImage('assets/back.png'),
                          fit: BoxFit.fitHeight)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                                alignment: AlignmentDirectional.bottomCenter,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: size.width * 0.7),
                                  child: Text(
                                    widget.course.courseTitle,
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle.copyWith(
                                        fontSize: 32,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: Navigator.of(context).pop,
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_rounded),
                        hintText: "Search Course",
                        filled: true,
                        fillColor: const Color.fromARGB(255, 233, 233, 233),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16)),
                    style: primaryTextStyle,
                  ),
                ),
                // const SizedBox(height: 10),
                Expanded(
                    child: ListView.builder(
                        itemCount: materials.length,
                        itemBuilder: (context, index) => Column(
                              children: [
                                ListTile(
                                  onTap: () async {
                                    // Navigator.of(
                                    //         context)
                                    //     .push(MaterialPageRoute(
                                    //         builder: (context) => PdfViewTest(
                                    //               materialModel:
                                    //                   materials[index],
                                    //             )));
                                    var resentlyView = await Navigator.of(
                                            context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => PdfViewPage(
                                                  materialModel:
                                                      materials[index],
                                                )));
                                                
                                    if (resentlyView != null) {
                                      RecentViewedBox.addToList(resentlyView);
                                      updateMaterial(resentlyView);
                                    }
                                  },
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: const Color.fromARGB(
                                        255, 228, 228, 228),
                                    child: SvgPicture.asset(
                                      'assets/svg/bxs_file-doc.svg',
                                      width: 25,
                                    ),
                                  ),
                                  title: Text(materials[index].fileName,
                                      maxLines: 2,
                                      style: primaryTextStyle.copyWith(
                                          fontSize: 15,
                                          color: const Color.fromARGB(
                                              255, 56, 56, 56))),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: LinearProgressIndicator(
                                      minHeight: 7,
                                      color: const Color(0xff6259FF),
                                      backgroundColor: const Color(0xff6259FF)
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5),
                                      value: materials[index].initialPage /
                                          (materials[index].totalPages ?? 1),
                                    ),
                                  ),
                                  // Text('Jun 12',
                                  //     style: primaryTextStyle.copyWith(
                                  //         fontSize: 14, color: Colors.grey)),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.more_vert_rounded),
                                  ),
                                ),
                                const Divider(
                                  height: 5,
                                  thickness: 4,
                                )
                              ],
                            )))
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xff6259FF),
          extendedPadding: const EdgeInsets.symmetric(horizontal: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          label: Row(
            children: [
              const Icon(Icons.add),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Add Note",
                style: primaryTextStyle.copyWith(
                    fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          onPressed: () {}),
    );
  }

  void updateMaterial(MaterialModel model) {
    materials = materials.map((e) {
      if (e.fileName == model.fileName) {
        return model;
      }
      return e;
    }).toList();
    setState(() {});
    MaterialBox.materialBox.put(widget.course.materialFolder,
        materials.map((e) => jsonEncode(e.toJson())).toList());
  }
}
