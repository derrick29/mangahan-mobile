import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangahan/components/chaptersList.dart';
import 'package:mangahan/components/mangaInfBtn.dart';
import 'package:mangahan/globals.dart' as globals;
import 'package:mangahan/models/mangaModel.dart';
import 'package:mangahan/db/db.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:mangahan/constants/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' show get;
import 'package:path/path.dart' as path;

class MangaInfo extends StatefulWidget {
  final String mangaImg, mangaTitle, mangaUrl;
  final List<Map<String, dynamic>> chaptersList;

  const MangaInfo({Key? key, required this.mangaImg, required this.chaptersList, required this.mangaTitle, required this.mangaUrl}) : super(key: key);

  @override
  State<MangaInfo> createState() => _MangaInfoState();
}

class _MangaInfoState extends State<MangaInfo> {
  late Manga manga;
  bool isFav = false;
  bool isDl = false;

  void addToFav() async {
    if(!isFav){
      final manga = Manga(title: widget.mangaTitle, imgUrl: widget.mangaImg, mangaUrl: widget.mangaUrl, chaptersList: widget.chaptersList, createdAt: DateTime.now());
      Manga savedManga = await DBHelper.instance.create(manga, mangaTable);
      setState(() {
        setState(() {
          isFav = true;
        });
      });
    }else{
      await DBHelper.instance.deleteByTitle(widget.mangaTitle, mangaTable);
      setState(() {
        setState(() {
          isFav = false;
        });
      });
    }
  }

  Future<List<String>> getMangaImgs(String chapUrl) async {
    String subUrl = chapUrl.split('.com')[1];
    List<String> returnImgs = [];
    final webscraper = WebScraper(Constants.baseUrl);
    if(await webscraper.loadWebPage(subUrl)) {
      List<Map<String, dynamic>> mangaImgs = webscraper.getElement('div.page-break.no-gaps > img', ['data-src']);
      for(int i = 0; i < mangaImgs.length; i++) {
        returnImgs.add(mangaImgs[i]['attributes']['data-src']);
      }
    }

    return returnImgs;
  }

  void download() async {
    if(!isDl){
      List<Map<String, dynamic>> chapLists = widget.chaptersList;
      chapLists = chapLists.reversed.toList();
      for(int i = 0; i < chapLists.length; i++){
        print("test-$i");
        List<String> imgUrls = await getMangaImgs(chapLists[i]['attributes']['href']);
        List<String> imgPaths = [];
        if(imgUrls.length > 0){
          for(int j = 0; j < imgUrls.length; j++){
            String currImgPath = await downloadImg(imgUrls[j], widget.mangaTitle, chapLists[i]['title'].toString().trim());
            imgPaths.add(currImgPath);
          }
        }
        chapLists[i]['attributes']['imgUrls'] = imgPaths;
        print("${chapLists[i]['title'].toString().trim()} ${imgPaths}");
      }

      final manga = Manga(title: widget.mangaTitle, imgUrl: widget.mangaImg, mangaUrl: widget.mangaUrl, chaptersList: chapLists, createdAt: DateTime.now());
      Manga savedManga = await DBHelper.instance.create(manga, mangaDlTable);
      print(savedManga);
    }else{
      await DBHelper.instance.deleteByTitle(widget.mangaTitle, mangaDlTable);
      setState(() {
        setState(() {
          isDl = false;
        });
      });
    }
  }

  Future<String> downloadImg(String url, String mangaTitle, String chapt) async {
    final response = await get(Uri.parse(url.trim()));

    // Get the image name
    final imageName = path.basename(url);
    // Get the document directory path
    final appDir = await getApplicationDocumentsDirectory();

    // This is the saved image path
    // You can use it to display the saved image later.
    final mangaPath = path.join(appDir.path, mangaTitle);
    final mangaFolder = Directory(mangaPath);
    if(await mangaFolder.exists() == false){
      mangaFolder.create();
    }

    final localPath = path.join(appDir.path, mangaTitle, '${chapt}-${imageName}');

    // Downloading
    final File imageFile = File(localPath);
    await imageFile.writeAsBytes(response.bodyBytes);
    return localPath;
  }

  Future<bool> checkIsDl() async {
    return await DBHelper.instance.isMangaSaved(widget.mangaTitle, mangaDlTable);
  }

  void allFav() async {
    // await DBHelper.instance.deleteAll();
    List<Manga> mangas = await DBHelper.instance.getAllMangas();
    globals.favMangas = mangas;
    globals.favMangas.forEach((element) {
      print('${element.id} -- ${element.title}');
    });
  }

  Future<bool> checkFav() async {
    return await DBHelper.instance.isMangaSaved(widget.mangaTitle, mangaTable);
  }

  void initCheckIsFav() async {
    bool isF = await checkFav();
    setState(() {
      setState(() {
        isFav = isF;
      });
    });
  }

  void initCheckisDl() async {
    bool isD = await checkIsDl();
    setState(() {
      setState(() {
        isDl = isD;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCheckIsFav();
    initCheckisDl();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 285,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 175,
                    width: 130,
                    child: Image.network(
                        widget.mangaImg,
                        fit: BoxFit.cover,
                    ),
                  ),
                  Text("Author: TEST", style: TextStyle(color: Colors.white),)
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: allFav,
                  child: InfoBtn(icon: Icons.play_arrow_outlined, btnText: "Read"),
                ),
                GestureDetector(
                  onTap: download,
                  child: InfoBtn(icon: isDl ? Icons.download : Icons.download_outlined, btnText: "Download"),
                ),
                GestureDetector(
                  onTap: addToFav,
                  child: InfoBtn(icon: isFav ? Icons.favorite_outlined : Icons.favorite_outline, btnText: "Favorite"),
                ),
              ],
            ),
          ),
          Container(
            height: 10,
            width: double.infinity,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
