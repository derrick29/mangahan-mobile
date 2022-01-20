import 'dart:convert';
import 'dart:io';

import 'package:mangahan/constants/constants.dart';
import 'package:mangahan/models/mangaModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();

  static Database? _database;

  DBHelper._init();

  Future<Database?> get database async {
    if(_database != null) return _database;
    _database = await _initiateDb();
    return _database;
  }

  Future<Database> _initiateDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, Constants.DB_NAME);
    return await openDatabase(path, version: Constants.DB_VERSION, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $mangaTable(
      ${MangaFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${MangaFields.title} TEXT NOT NULL,
      ${MangaFields.imgUrl} TEXT NOT NULL,
      ${MangaFields.mangaUrl} TEXT NOT NULL,
      ${MangaFields.chaptersList} TEXT NOT NULL,
      ${MangaFields.createdAt} TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $mangaDlTable(
      ${MangaFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${MangaFields.title} TEXT NOT NULL,
      ${MangaFields.imgUrl} TEXT NOT NULL,
      ${MangaFields.mangaUrl} TEXT NOT NULL,
      ${MangaFields.chaptersList} TEXT NOT NULL,
      ${MangaFields.createdAt} TEXT NOT NULL
      )
    ''');
  }

  Future<Manga> create(Manga manga, String tbl) async {
    final db = await instance.database;
    final isFav = await isMangaSaved(manga.title, tbl);
    final id = !isFav ? await db?.insert(tbl, manga.toJson()) : 0;
    return manga.copy(id: id);
  }

  Future<Manga> getManga(int id) async {
    final db = await instance.database;
    final maps = await db!.query(
      mangaTable,
      columns: MangaFields.values,
      where: '${MangaFields.id} = ?',
      whereArgs: [id]
    );

    if(maps.length > 0){
      return Manga.fromJson(maps.first, mangaTable);
    }else{
      throw Exception('ID $id not found');
    }
  }

  Future<bool> isMangaSaved(String title, String tbl) async {
    final db = await instance.database;
    final maps = await db!.query(
        tbl,
        columns: MangaFields.values,
        where: '${MangaFields.title} = ?',
        whereArgs: [title]
    );

    if(maps.length > 0){
      return true;
    }else{
      return false;
    }
  }

  Future<Manga> getMangaByTitle(String title, String tbl) async {
    final db = await instance.database;
    final maps = await db!.query(
        tbl,
        columns: MangaFields.values,
        where: '${MangaFields.title} = ?',
        whereArgs: [title]
    );

    if(maps.length > 0){
      return Manga.fromJson(maps[0], tbl);
    }else{
      throw Exception("No Manga Found");
    }
  }

  Future<List<Manga>> getAllMangas() async {
    final db = await instance.database;
    final result = await db!.query(mangaTable, orderBy: '${MangaFields.createdAt} DESC');
    return result.map((json) => Manga.fromJson(json, mangaTable)).toList();
  }

  Future<List<Manga>> getAllDlMangas(String tbl) async {
    final db = await instance.database;
    final result = await db!.query(tbl, orderBy: '${MangaFields.createdAt} DESC');
    return result.map((json) => Manga.fromJson(json, mangaDlTable)).toList();
  }

  Future<int> delete(int? id, String tbl) async {
    final db = await instance.database;
    return await db!.delete(
        tbl,
      where: '${MangaFields.id} = ?',
      whereArgs: [id]
    );
  }

  Future<int> deleteByTitle(String title, String tbl) async {
    final db = await instance.database;
    return await db!.delete(
        tbl,
        where: '${MangaFields.title} = ?',
        whereArgs: [title]
    );
  }

  Future<int> deleteAll() async {
    final db = await instance.database;
    return await db!.delete(
      mangaTable,
      where: '${MangaFields.id} > ?',
      whereArgs: [0]
    );
  }

  Future close() async {
    final db = await instance.database;
    db?.close();
  }


}