import 'package:flutter/material.dart';
import 'package:mangahan/components/chaptersList.dart';
import 'package:mangahan/components/mangaInfo.dart';
import 'package:mangahan/constants/constants.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:mangahan/globals.dart' as globals;
import 'package:mangahan/db/db.dart';
import 'package:mangahan/models/mangaModel.dart';

class MangaDetail extends StatefulWidget {
  final String mangaImg, mangaTitle, mangaUrl;
  final bool fromDl;

  const MangaDetail({Key? key, required this.mangaImg, required this.mangaTitle, required this.mangaUrl, required this.fromDl}) : super(key: key);
  @override
  _MangaDetailState createState() => _MangaDetailState();
}

class _MangaDetailState extends State<MangaDetail> {
  bool detailsLoaded = false;

  late List<Map<String, dynamic>> chaptersList;

  void getDetails() async {
    if(!widget.fromDl) {
      String subUrl = widget.mangaUrl.split('.com')[1];
      final webscraper = WebScraper(Constants.baseUrl);
      if(await webscraper.loadWebPage(subUrl)) {
        setState(() {
          chaptersList = webscraper.getElement('li.wp-manga-chapter > a', ['href']);
          globals.currentChaptersList = chaptersList;
          setState(() {
            setState(() {
              detailsLoaded = true;
            });
          });
        });
      }
    }else{
      Manga manga = await DBHelper.instance.getMangaByTitle(widget.mangaTitle, mangaDlTable);
      chaptersList = manga.chaptersList.reversed.toList();
      globals.currentChaptersList = chaptersList;
      setState(() {
        setState(() {
          detailsLoaded = true;
        });
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mangaTitle),
        centerTitle: true,
      ),
      body: detailsLoaded ? Container(
        height: screenSize.height,
        width: screenSize.width,
        color: Constants.lightGrey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              MangaInfo(mangaImg: widget.mangaImg, chaptersList: chaptersList, mangaTitle: widget.mangaTitle, mangaUrl: widget.mangaUrl),
              ChaptersList(chapters: chaptersList, fromDl: widget.fromDl)
            ],
          ),
        ),
      ) : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
