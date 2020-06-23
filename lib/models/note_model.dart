class NoteModel {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  NoteModel(this._title, this._date, this._priority, [this._description]);

  NoteModel.withId(this._id, this._title, this._date, this._priority,
      [this._description]);

  int get priority => _priority;

  set priority(int value) {
    this._priority = value;
  }

  String get date => _date;

  set date(String value) {
    this._date = value;
  }

  String get description => _description;

  set description(String value) {
    this._description = value;
  }

  String get title => _title;

  set title(String value) {
    this._title = value;
  }

  int get id => _id;

  // Convert a note object into a map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;

    return map;
  }

  //Extract a note object from a map object
  NoteModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this._priority = map['priority'];
  }
}
