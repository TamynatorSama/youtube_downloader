import 'package:flutter/material.dart';
import 'package:smooth_study/model/department_model.dart';
import 'package:smooth_study/screens/course_material_listing.dart';
import 'package:smooth_study/utils/theme.dart';

class CoursesPage extends StatelessWidget {
  final Level currentLevel;
  const CoursesPage({super.key,required this.currentLevel});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).padding.top, horizontal: 24),
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
                          child: Text(
                            currentLevel.levelName,
                            style: primaryTextStyle.copyWith(fontSize: 32,color: Colors.white,fontWeight: FontWeight.w600),
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16)),
              style: primaryTextStyle,
            ),
          ),
          // const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: currentLevel.courses.length,
              itemBuilder: (context, index) => Column(
                children: [
                  ListTile(
                    onTap: () async{
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CourseMaterialListing(course: currentLevel.courses[index],levelName: currentLevel.levelName ,),
                        ),
                      );
                    },
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Color.fromARGB(255, 228, 228, 228),
                      child: Icon(Icons.military_tech, size: 25,color: Colors.black,),
                    ),
                    title: Text(
                      currentLevel.courses[index].courseCode,
                      style: primaryTextStyle,
                    ),
                    subtitle: Text(
                      currentLevel.courses[index].courseTitle,
                      style: primaryTextStyle.copyWith(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 4,
                  )
                ],
              ),
            ),
          ),
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
          onPressed: () {
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => const PdfViewPage(m)));
          }),
    );
  }
}
