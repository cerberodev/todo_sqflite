import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteList extends StatefulWidget {
  NoteList({Key key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do App'),
      ),
      //body: ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteList() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),
            title: Text(
              this.noteList[position].title,
              style: titleStyle,
            ),
            subtitle: Text(this.noteList[position].date),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.blueGrey;
        break;
      case 2:
        return Colors.cyanAccent;
        break;

      default:
        return Colors.blueGrey;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow_outlined);
        break;
      case 2:
        return Icon(Icons.play_arrow_sharp);
        break;

      default:
        return Icon(Icons.play_arrow_outlined);
    }
  }

  void _delete(context, Note note) async {}
}
