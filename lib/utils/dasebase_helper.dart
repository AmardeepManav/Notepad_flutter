import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:notepad/models/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton Constructor
  static Database _database;

  String noteTable = "note_table";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colDate = "date";
  String colPriority = "priority";

  DatabaseHelper._createInstance(); // named Constructor to create instance of database

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // get a directory path for android and ios to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'note.db';

    // open and create a database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

// fetch all note list
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

// insert note
  Future<int> insertNote(NoteModel noteModel) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, noteModel.toMap());
    return result;
  }

// update note
  Future<int> updateNote(NoteModel noteModel) async {
    Database db = await this.database;
    var result = await db.update(noteTable, noteModel.toMap(),
        where: '$colId = ?', whereArgs: [noteModel.id]);
    return result;
  }

// delete note
  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  // get Number of Note
  Future<int> getNoteCount() async {
    Database db = await this.database;

    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    var result = Sqflite.firstIntValue(x);
    return result;
  }

  // get Number of Note
  Future<List<NoteModel>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    debugPrint(noteMapList.toString());
    int count = noteMapList.length;

    List<NoteModel> noteList = List<NoteModel>();
    for (int i = 0; i < count; i++) {
      noteList.add(NoteModel.fromMapObject(noteMapList[i]));

    }

    return noteList;
  }
}
