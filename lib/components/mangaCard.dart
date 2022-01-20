import 'package:flutter/material.dart';
import 'package:mangahan/components/mangaDetail.dart';
import 'package:mangahan/constants/constants.dart';

class MangaCard extends StatelessWidget {
  final String mangaImg, mangaTitle, mangaUrl;
  final bool fromDl;

  const MangaCard({Key? key, required this.mangaImg, required this.mangaTitle, required this.mangaUrl, required this.fromDl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 130,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => MangaDetail(mangaImg: mangaImg, mangaTitle: mangaTitle, mangaUrl: mangaUrl, fromDl: fromDl)
          ));
        },
        child: Column(
          children: [
            Expanded(
              flex: 70,
              child: Image.network(
                  mangaImg,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if(loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
              ),
            ),
            Expanded(
              flex: 30,
              child: Container(
                alignment: Alignment.centerLeft,
                child: (
                    Text(
                      mangaTitle,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )
                ),
                color: Constants.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
