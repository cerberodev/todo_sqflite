import 'package:flutter/material.dart';
import 'package:todo_sqflite/screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.yellow,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      title: 'To Do SQFlite',
      home: NoteList(),
    );
  }
}
