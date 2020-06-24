import 'package:flutter/material.dart';
import 'package:notepad/models/note_model.dart';
import 'package:notepad/utils/dasebase_helper.dart';
import 'package:intl/intl.dart';

class NoteDetailScreen extends StatefulWidget {
  String appbarTitle;
  NoteModel noteModel;

  NoteDetailScreen(this.noteModel, this.appbarTitle);

  @override
  _NoteDetailScreenState createState() =>
      _NoteDetailScreenState(noteModel, appbarTitle);
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  static var _priorities = ["High", "Low"];

  String appbarTitle;
  NoteModel noteModel;
  TextEditingController titleController = new TextEditingController();
  TextEditingController descController = new TextEditingController();

  _NoteDetailScreenState(this.noteModel, this.appbarTitle);

  // database helper class
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = noteModel.title;
    descController.text = noteModel.description;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(appbarTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                moveToLastScreen();
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String dropdownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropdownStringItem,
                        child: Text(dropdownStringItem),
                      );
                    }).toList(),
                    style: textStyle,
                    value: getPriorityAsString(noteModel.priority),
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User Selected -- $valueSelectedByUser');
                        updatePriorityAsInt(valueSelectedByUser);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: titleController,
                    cursorColor: Colors.black,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('title changed');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: descController,
                    cursorColor: Colors.black,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('description changed');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint('Delete button Press');
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 4.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _save();
                              debugPrint('Save button Press');
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        noteModel.priority = 1;
        break;
      case 'Low':
        noteModel.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // high
        break;
      case 2:
        priority = _priorities[1]; // low
        break;
    }
    return priority;
  }

  // update title
  void updateTitle() {
    noteModel.title = titleController.text;
  }

  void updateDescription() {
    noteModel.description = descController.text;
  }

  //save to database
  void _save() async {
    moveToLastScreen();
    noteModel.date = DateFormat.yMMM().format(DateTime.now());
    int result;
    if (noteModel.id != null) {
      result = await databaseHelper.updateNote(noteModel);
    } else {
      result = await databaseHelper.insertNote(noteModel);
    }

    if (result != 0) {
      _showAlertDialog('Success', 'Note Saved Successfully!');
    } else {
      _showAlertDialog('Failure', 'Problem!');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
