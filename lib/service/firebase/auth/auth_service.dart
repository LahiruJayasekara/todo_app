import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/service/firebase/database/database_service.dart';
import 'package:todo_app/service/modals/user.dart';

import '../../network.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  // auth change user stream
  Stream<UserID> get userID {
    return _auth.authStateChanges()
        .map((event) => event != null ? UserID(uid: event.uid) : null);
  }

  // register with email and password
  Future<NetworkStatus> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await DatabaseService(uid: userCredential.user.uid).updateUserDataWhenRegister(
          UserData(
              uid: userCredential.user.uid,
              name: 'Temp Name',
              age: 0,
              mobileNumber: '',
              todos: []));
      return SuccessState<UserID>(data: UserID(uid: userCredential.user.uid));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return ErrorState(error: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return ErrorState(error: 'The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print("Invalid email");
        return ErrorState(error: 'Invalid email');
      } else {
        print("other error register ${e.message}");
        return NetworkErrorState(
            error: 'Error occurred while trying to register');
      }
    } catch (e) {
      print(e);
      return NetworkErrorState(
          error: 'Error occurred while trying to register');
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return SuccessState<UserID>(data: UserID(uid: userCredential.user.uid));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return ErrorState(error: 'No user found for the email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return ErrorState(error: 'Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        print("Invalid email");
        return ErrorState(error: 'Invalid email');
      } else {
        print("other error login ${e.message}");
        return NetworkErrorState(error: 'Error occurred while trying to login');
      }
    } catch (e) {
      print(e);
      return NetworkErrorState(error: 'Error occurred while trying to login');
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
