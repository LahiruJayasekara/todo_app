import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/common/utils.dart';
import 'package:todo_app/service/firebase/auth/auth_service.dart';
import 'package:todo_app/service/network.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String error = '';
  bool loading = false;

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Text(
                    'TODO APP',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
                  )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 300),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Register",
                        style: TextStyle(fontSize: 40, letterSpacing: 2, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (value) => value.isEmpty ? "Email can't be empty" : null,
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                decoration: textInputDecorationLoginForms.copyWith(hintText: "Email"),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                obscureText: true,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Password can't be empty";
                                  else if (value.length < 6)
                                    return "Password should contain atleast 6 characters";
                                  else
                                    return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                decoration: textInputDecorationLoginForms.copyWith(hintText: "Password"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.orange[200];
                                else if (states.contains(MaterialState.disabled))
                                  return Colors.orange[200];

                                return Colors.orange; // Use the component's default.
                              },
                              ),
                            ),
                            // style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.orange), ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Register',
                                  style: TextStyle(color: Colors.white),
                                ),
                                loading ? Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                ) : Text(''),
                              ],
                            ),
                            onPressed:  loading ? null
                                : () async {
                              error = '';
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                NetworkStatus result = await _auth
                                    .registerWithEmailAndPassword(email, password);
                                print("Register result $result");
                                if (result is SuccessState) {
                                  setState(() {
                                    loading = false;
                                    error = '';
                                  });
                                } else if (result is ErrorState) {
                                  setState(() {
                                    loading = false;
                                    error = result.error;
                                  });
                                } else if (result is NetworkErrorState){
                                  setState(() {
                                    loading = false;
                                    error = result.error;
                                  });
                                }
                              } else {
                                setState(() {
                                  loading = false;
                                  error = '';
                                });
                              }
                            }
                        ),
                      ),
                      TextButton(
                          onPressed: () => {widget.toggleView()},
                          style: ButtonStyle(overlayColor: MaterialStateProperty.all<Color>(Colors.orange[100])),
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.orange),
                          )
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "Powered by MLPJDroid",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
