import 'package:flutter/material.dart';
import 'package:mangahan/constants/constants.dart';

import 'mangaCard.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> mangaList;
  final List<Map<String, dynamic>> mangaUrlList;
  const SearchPage({Key? key, required this.mangaList, required this.mangaUrlList}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
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
                  "Searched Items (${widget.mangaList.length.toString()})",
                  style: TextStyle(
                      fontSize: 23,
                      color: Colors.white
                  ),
                ),
              ),
              for(int i = 0; i < widget.mangaList.length; i++)
                MangaCard(
                  mangaImg: widget.mangaList[i]['attributes']['data-src'],
                  mangaTitle: widget.mangaUrlList[i]['attributes']['title'],
                  mangaUrl: widget.mangaUrlList[i]['attributes']['href'],
                  fromDl: false,
                )
            ],
          ),
        ),
      ),
    );
  }
}
