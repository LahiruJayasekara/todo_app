import 'package:todo_app/service/modals/todo.dart';

class UserID {
  final String uid;

  UserID({this.uid});
}


class UserData {

  final String uid;
  final String name;
  final int age;
  final String mobileNumber;
  final List<TODO> todos;


  UserData({ this.uid, this.name, this.age, this.mobileNumber, this.todos });

}