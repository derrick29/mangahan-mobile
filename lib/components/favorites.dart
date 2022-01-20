import 'package:flutter/material.dart';
import 'package:mangahan/constants/constants.dart';
import 'package:mangahan/globals.dart' as globals;

import 'mangaCard.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                "Favorites (${globals.favMangas.length.toString()})",
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.white
                ),
              ),
            ),
            for(int i = 0; i < globals.favMangas.length; i++)
              MangaCard(
                mangaImg: globals.favMangas[i].imgUrl,
                mangaTitle: globals.favMangas[i].title,
                mangaUrl: globals.favMangas[i].mangaUrl,
                fromDl: false,
              )
          ],
        ),
      ),
    );
  }
}
