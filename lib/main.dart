import 'package:flutter/material.dart';
import 'package:todo_app/screens/main_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/service/firebase/auth/auth_service.dart';
import 'package:todo_app/service/modals/user.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
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
        if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<UserID>.value(
              value: AuthService().userID,
              child: MaterialApp(
                title: 'Flutter Demo',
                home: MainWrapper(),
              ),
            );
        }

        // Otherwise, show something whilst waiting for initialization to complete
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
    );
  }
}