import 'package:flutter/material.dart';
import 'package:notepad/screens/note_detail.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NoteList"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NoteDetailScreen("Add Note");
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
