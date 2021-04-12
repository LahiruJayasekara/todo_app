import 'package:flutter/cupertino.dart';
import 'package:todo_app/screens/authenticate/register.dart';
import 'package:todo_app/screens/authenticate/log_in.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLogin = true;

  void _toggleLogin() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LogIn(toggleView: _toggleLogin,);
    } else {
      return Register(toggleView: _toggleLogin,);
    }
  }
}
