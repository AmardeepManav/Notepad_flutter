import 'package:flutter/material.dart';

class NoteDetailScreen extends StatefulWidget {
  String appbarTitle;

  NoteDetailScreen(this.appbarTitle);

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState(appbarTitle);
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  static var _priorities = ["High", "Low"];

  String appbarTitle;
  TextEditingController titleController = new TextEditingController();
  TextEditingController descController = new TextEditingController();

  _NoteDetailScreenState(this.appbarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
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
                    value: 'Low',
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User Selected -- $valueSelectedByUser');
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
                      debugPrint('title changed');
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
    Navigator.pop(context);
  }
}
