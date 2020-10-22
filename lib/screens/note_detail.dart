import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_sqflite/models/note.dart';
import 'package:todo_sqflite/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.appBarTitle, this.note);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High', 'Low'];

  DataBaseHelper helper = DataBaseHelper();

  String appBarTitle;
  Note note;
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool _enabled = false;
  NoteDetailState(this.note, this.appBarTitle);
  @override
  void initState() {
    super.initState();
    titleController.addListener(() {
      !titleController.text.isEmpty && descriptionController.text.isNotEmpty
          ? _enabled = true
          : _enabled = false;
      setState(() {});
    });

    descriptionController.addListener(() {
      !descriptionController.text.isEmpty && titleController.text.isNotEmpty
          ? _enabled = true
          : _enabled = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Form(
          key: _key,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    style: textStyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        updatePriorityAsInt(valueSelectedByUser);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    validator: (String value) {
                      return value.isEmpty
                          ? 'Do not completed Title: Text Form Field.'
                          : null;
                    },
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Changed in Title of text field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.book),
                      ),
                      icon: IconButton(
                        icon: Icon(Icons.book),
                        onPressed: () {},
                        tooltip: 'Text',
                      ),
                      prefixIcon: Icon(Icons.book),
                      helperText: 'Adding your Title',
                    ),
                    maxLength: 15,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    validator: (String value) {
                      return value.isEmpty
                          ? 'Do not completed Description Text Form Field.'
                          : null;
                    },
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Changed in Description of text field');
                      updateDescription();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save),
                              Text('Save'),
                            ],
                          ),
                          onPressed: _enabled
                              ? () {
                                  setState(() {
                                    debugPrint('OnPressed Save Raised Button');
                                    _save();
                                  });
                                }
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: FlatButton(
                          color: Colors.blue,
                          child: Text('Delete'),
                          onPressed: () {
                            setState(() {
                              debugPrint('OnPressed Delete Raised Button');
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {
    if (!_key.currentState.validate()) {
      return;
    }

    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (note.id == null) {
      _showAlertDialog('Status', 'No note was deleted');
      return;
    }

    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Succesfully');
    } else {
      _showAlertDialog('Status', 'Error Occured when Deleting Note');
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
