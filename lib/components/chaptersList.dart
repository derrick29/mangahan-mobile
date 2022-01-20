import 'package:flutter/material.dart';
import 'package:mangahan/components/readView.dart';
import 'package:mangahan/constants/constants.dart';
import 'package:mangahan/globals.dart' as globals;

class ChaptersList extends StatelessWidget {
  final List<Map<String, dynamic>> chapters;
  final bool fromDl;

  const ChaptersList({Key? key, required this.chapters, required this.fromDl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: chapters.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            height: 50,
            width: double.infinity,
            child: Material(
              color: Constants.lightGrey,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ReadView(chapterUrl: fromDl ? chapters[index]['attributes'].href : chapters[index]['attributes']['href'], index: index, fromDl: fromDl,);
                    }
                  ));
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      chapters[index]['title'].toString().trim(),
                      style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
