import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TODOCard extends StatelessWidget {
  final dynamic todo;
  final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

  TODOCard({this.todo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.orange[100],
            child: Icon(Icons.event, size: 40,color: Colors.orange,),
          ),
          title: Text(dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(todo['dueDate']).toLocal())),
          subtitle: Text(todo['task']),
        ),
      ),
    );
  }
}
