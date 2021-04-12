import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/service/modals/todo.dart';
import 'package:todo_app/service/modals/user.dart';

class DatabaseService {

  final String uid;

  DatabaseService({ this.uid });

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');


  Future<void> updateUserDataWhenRegister(UserData userData) async {
    return await users
        .doc(uid)
        .set({
          'name': userData.name,
          'age': userData.age,
          'mobileNumber': userData.mobileNumber,
          'todos': userData.todos
        }, SetOptions(merge: true))
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUserData(UserData userData) async {
    return await users
        .doc(uid)
        .set({
          'name': userData.name,
          'age': userData.age,
          'mobileNumber': userData.mobileNumber
        }, SetOptions(merge: true))
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUserTODOs(TODO todo) async {
    return await users
        .doc(uid)
        .set({'todos': FieldValue.arrayUnion([{'task': todo.task, 'dueDate': todo.dueDate}])}, SetOptions(merge: true));
  }

  Future getUserData() async {
    return users.doc(uid).get();
  }

  Stream get userDate {
    return users.doc(uid).snapshots();
  }
}
