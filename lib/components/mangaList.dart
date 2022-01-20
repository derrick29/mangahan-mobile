import 'package:flutter/material.dart';
import 'package:mangahan/constants/constants.dart';

import 'mangaCard.dart';

class MangaList extends StatelessWidget {
  final List<Map<String, dynamic>> mangaList;
  final List<Map<String, dynamic>> mangaUrlList;
  const MangaList({Key? key, required this.mangaList, required this.mangaUrlList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      color: Constants.black,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Wrap(
          runSpacing: 10,
          children: [
            Container(
              width: double.infinity,
              height: 30,
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                "Latest Manga (${mangaList.length.toString()})",
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.white
                ),
              ),
            ),
            for(int i = 0; i < mangaList.length; i++)
              MangaCard(
                mangaImg: mangaList[i]['attributes']['data-src'],
                mangaTitle: mangaUrlList[i]['attributes']['title'],
                mangaUrl: mangaUrlList[i]['attributes']['href'],
                fromDl: false,
              )
          ],
        ),
      ),
    );
  }
}
