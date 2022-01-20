import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mangahan/components/botNavItem.dart';
import 'package:mangahan/components/downloads.dart';
import 'package:mangahan/components/favorites.dart';
import 'package:mangahan/components/mangaCard.dart';
import 'package:mangahan/components/mangaList.dart';
import 'package:mangahan/components/searchPage.dart';
import 'package:mangahan/constants/constants.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:mangahan/db/db.dart';
import 'package:mangahan/models/mangaModel.dart';
import 'package:mangahan/globals.dart' as globals;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNavIdx = 0;

  bool pageLoaded = false;
  late List<Map<String, dynamic>> mangaList;
  late List<Map<String, dynamic>> mangaUrlList;

  bool displaySearch = false;

  var srchController = TextEditingController();

  void navBarClick(int idx) async{
    if(idx == 1) {
      List<Manga> mangas = await DBHelper.instance.getAllDlMangas(mangaDlTable);
      globals.dlMangas = mangas;
      for(int i = 0; i < mangas.length; i++) {
        print(mangas[i].title);
      }
    }
    if(idx == 2) {
      getFavs();
    }
    setState(() {
      selectedNavIdx = idx;
    });
  }

  void getFavs() async {
    List<Manga> mangas = await DBHelper.instance.getAllMangas();
    globals.favMangas = mangas;
  }

  void getDls() async {
    List<Manga> mangas = await DBHelper.instance.getAllDlMangas(mangaDlTable);
    globals.dlMangas = mangas;
  }

  void getManga() async {
    final webscraper = WebScraper(Constants.baseUrl);
    if(await webscraper.loadWebPage('/')) {
      setState(() {
        mangaList = webscraper.getElement('div.page-item-detail.manga > div.item-thumb > a > img', ['data-src', 'alt']);
        mangaUrlList = webscraper.getElement('div.page-item-detail.manga > div.item-thumb > a', ['href', 'title']);
        setState(() {
          pageLoaded = true;
        });
      });
    }
  }

  void searchManga() async {
    //deal with error later
    if(displaySearch){
      final webscraper = WebScraper(Constants.baseUrl);
      String srchTxt = srchController.value.text;
      List<Map<String, dynamic>> srchList;
      List<Map<String, dynamic>> srchUrlList;

      if(await webscraper.loadWebPage('?s=$srchTxt&post_type=wp-manga')) {
          srchList = webscraper.getElement('div.c-tabs-item__content > div > div.tab-thumb > a > img', ['data-src', 'alt']);
          srchUrlList = webscraper.getElement('div.c-tabs-item__content > div > div.tab-thumb > a', ['href', 'title']);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return SearchPage(mangaList: srchList, mangaUrlList: srchUrlList);
            }
          ));
      }
    }
    setState(() {
      displaySearch = !displaySearch;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavs();
    getDls();
    getManga();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: !displaySearch ?
          Text('Mangahan') : TextField(
            decoration: InputDecoration(hintText: 'Search', hintStyle: TextStyle(color: Colors.white)),
            style: TextStyle(color: Colors.white),
            controller: srchController,
            onTap: (){},
        ),
        backgroundColor: Constants.darkGrey,
        actions: [
          IconButton(
              onPressed: searchManga,
              icon: Icon(Icons.search)
          )
        ],
      ),
      body: pageLoaded ? selectedNavIdx == 0 ? MangaList(mangaList: mangaList, mangaUrlList: mangaUrlList) : selectedNavIdx == 1 ? Downloads() : Favorites() : Center(
        child: CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Constants.darkGrey,
        selectedItemColor: Constants.lightBlue,
        unselectedItemColor: Colors.white,
        currentIndex: selectedNavIdx,
        onTap: navBarClick,
        items: [
          botNavItem(Icons.explore_outlined, 'HOME'),
          botNavItem(Icons.download_outlined, "SAVED"),
          botNavItem(Icons.favorite_outlined, "FAVORITES"),
        ],
      ),
    );
  }
}
