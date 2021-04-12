import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/body/todo_list/todo_card.dart';
import 'package:todo_app/service/firebase/database/database_service.dart';
import 'package:todo_app/service/modals/user.dart';
import 'add_todo.dart';
import 'package:provider/provider.dart';



class TODOList extends StatefulWidget {
  @override
  _TODOListState createState() => _TODOListState();
}

class _TODOListState extends State<TODOList> {
  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<UserID>(context);
    return Scaffold(
      body: StreamBuilder(
        // Initialize FlutterFire:
        // future: DatabaseService(uid: userID.uid).getUserData(),
        stream: DatabaseService(uid: userID.uid).userDate,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return MaterialApp(
              home: Scaffold(
                body: Text(
                    "Something went wrong!"
                ),
              ),
            );
          }

          // Once complete, show your application
          if (snapshot.hasData) {
            var todos = snapshot.data.data()['todos'];
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return TODOCard(todo: todos[index]);
              },
            );
          }

          // Otherwise, show something whilst waiting for fetching to complete
          return MaterialApp(
            home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                )
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () => {
          showModalBottomSheet(context: context, builder: (context) => AddTODOBottomSheet())
      },),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
