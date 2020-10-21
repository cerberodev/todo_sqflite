import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:todo_sqflite/models/note.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static DataBaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DataBaseHelper._createInstance();

  factory DataBaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DataBaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialzeDatabase();
    }
    return _database;
  }

  Future<Database> initialzeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTERGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription Text, $colPriority INTERGER, $colDate TEXT)');
  }
}
