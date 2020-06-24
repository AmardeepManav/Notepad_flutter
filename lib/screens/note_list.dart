import 'package:flutter/material.dart';
import 'package:notepad/models/note_model.dart';
import 'package:notepad/screens/note_detail.dart';
import 'package:notepad/utils/dasebase_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteListScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<NoteModel> noteList;
  int count;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<NoteModel>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("NoteList"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          navigateToDetailScreen(NoteModel('', '', 2), 'Add Note');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteNote(BuildContext context, NoteModel note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, "Note Delete Successfully!");
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String value) {
    final SnackBar snackBar = SnackBar(content: Text(value));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  ListView getNoteListView() {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 4.0,
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  noteList[position].title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(noteList[position].date),
              ),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                onTap: () {
                  _deleteNote(context, noteList[position]);
                },
              ),
              onTap: () {
                debugPrint('item click $position');
                navigateToDetailScreen(noteList[position], 'Edit Note');
              },
            ),
          );
        });
  }

  void navigateToDetailScreen(NoteModel noteModel, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetailScreen(noteModel, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<NoteModel>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
