import 'dart:convert';
import 'chapListItemModel.dart';

final String mangaTable = 'mangahan';
final String mangaDlTable = 'mangahan_dl';

class MangaFields {
  static final List<String> values = [id, title, imgUrl, mangaUrl, chaptersList, createdAt];
  static final String id = 'id';
  static final String title = 'title';
  static final String imgUrl = 'imgUrl';
  static final String mangaUrl = 'mangaUrl';
  static final String chaptersList = 'chaptersList';
  static final String createdAt = 'createdAt';
}

class Manga {
  final int? id;
  final String title;
  final String imgUrl;
  final String mangaUrl;
  final List<Map<String, dynamic>> chaptersList;
  final DateTime createdAt;

  const Manga({
    this.id,
    required this.title,
    required this.imgUrl,
    required this.mangaUrl,
    required this.chaptersList,
    required this.createdAt
  });

  Map<String, Object?> toJson() => {
    MangaFields.id: id,
    MangaFields.title: title,
    MangaFields.imgUrl: imgUrl,
    MangaFields.mangaUrl: mangaUrl,
    MangaFields.chaptersList: jsonEncode(chaptersList),
    MangaFields.createdAt: createdAt.toIso8601String()
  };

  Manga copy({
    int? id,
    String? title,
    String? imgUrl,
    String? mangaUrl,
    List<Map<String, dynamic>>? chaptersList,
    DateTime? createdAt
  }) => Manga(
    id: id ?? this.id,
    title: title ?? this.title,
    imgUrl: imgUrl ?? this.imgUrl,
    mangaUrl: mangaUrl ?? this.mangaUrl,
    chaptersList: chaptersList ?? this.chaptersList,
    createdAt: createdAt ?? this.createdAt
  );

  static Manga fromJson(Map<String, Object?> json, String tbl) {
    String? chapList = json[MangaFields.chaptersList] as String;
    return Manga(
        id: json[MangaFields.id] as int?,
        title: json[MangaFields.title] as String,
        imgUrl: json[MangaFields.imgUrl] as String,
        mangaUrl: json[MangaFields.mangaUrl] as String,
        chaptersList: (jsonDecode(chapList) as List).map((json) {
          dynamic item;
          item = tbl == mangaDlTable ? ChapListItemDl.fromJson(json) : ChapListItem.fromJson(json);
          Map<String, dynamic> e = {};
          e["title"] = item.title;
          e["attributes"] = item.attributes;
          return e;
        }).toList(),
        createdAt: DateTime.parse(json[MangaFields.createdAt] as String) as DateTime
    );
  }
}