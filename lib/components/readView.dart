import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangahan/constants/constants.dart';
import 'package:mangahan/models/chapListItemModel.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:mangahan/globals.dart' as globals;

class ReadView extends StatefulWidget {
  final String chapterUrl;
  final int index;
  final bool fromDl;
  const ReadView({Key? key, required this.chapterUrl, required this.index, required this.fromDl}) : super(key: key);

  @override
  _ReadViewState createState() => _ReadViewState();
}

class _ReadViewState extends State<ReadView> with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> mangaImgs;
  late ChapListImgs mangaImgsDl;

  bool mangaLoaded = false;

  void getMangaImgs() async {
    if(!widget.fromDl){
      String subUrl = widget.chapterUrl.split('.com')[1];
      final webscraper = WebScraper(Constants.baseUrl);
      if(await webscraper.loadWebPage(subUrl)) {
        setState(() {
          mangaImgs = webscraper.getElement('div.page-break.no-gaps > img', ['data-src']);
          setState(() {
            mangaLoaded = true;
          });
        });
      }
    }else{
      mangaImgsDl = globals.currentChaptersList[widget.index]['attributes'].imgUrls;
      setState(() {
        setState(() {
          mangaLoaded = true;
        });
      });
      for(int i = 0; i < mangaImgsDl.imgUrls.length; i++){
        print(mangaImgsDl.imgUrls[i]);
      }
    }

  }

  void onNavClick(int idx) {
    int idxToLoad = idx == 0 ?
    widget.index < globals.currentChaptersList.length - 1 ? widget.index + 1 : widget.index
        : widget.index > 0 ? widget.index - 1 : widget.index;
    print(idxToLoad);

    if(widget.index != idxToLoad) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return ReadView(chapterUrl: widget.fromDl ? globals
              .currentChaptersList[idxToLoad]['attributes'].href : globals
              .currentChaptersList[idxToLoad]['attributes']['href'],
              index: idxToLoad, fromDl: widget.fromDl,);
        }
      ));
    }else{
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMangaImgs();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: mangaLoaded ? Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.fromDl ? mangaImgsDl.imgUrls.length : mangaImgs.length,
          itemBuilder: (context, index) {
            return InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 1,
              maxScale: 2.0,
              child: widget.fromDl ? Image.file(
                  File(mangaImgsDl.imgUrls[index]),
                  fit: BoxFit.fitWidth,
              ) : Image.network(
                mangaImgs[index]['attributes']['data-src'].toString().trim(),
                fit: BoxFit.fitWidth,
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            );
          },
        ),
      ) : Container(
        child: CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        elevation: 0,
        onTap: onNavClick,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.chevron_left),
            label: ''
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            icon: Icon(Icons.chevron_right),
            label: ''
          )
        ],
    ),
    );
  }
}
