import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/authenticate/auth_wrapper.dart';
import 'package:todo_app/screens/body/home.dart';
import 'package:todo_app/service/modals/user.dart';

class MainWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<UserID>(context);

    if (userID == null) {
      return AuthWrapper();
    } else {
      return Home();
    }
  }
}
