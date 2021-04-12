import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/common/utils.dart';
import 'package:todo_app/service/firebase/database/database_service.dart';
import 'package:todo_app/service/firebase/storage/storage_service.dart';
import 'package:todo_app/service/modals/user.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/service/network.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<UserID>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        // Initialize FlutterFire:
        future: DatabaseService(uid: userID.uid).getUserData(),
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
            return ProfileDetails(profileData: snapshot.data.data());
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
      )
    );
  }
}

class ProfileDetails extends StatefulWidget {
  Map<String, dynamic> profileData;
  ProfileDetails({this.profileData});
  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final _formKey = GlobalKey<FormState>();

  String name;
  int age;
  String mobileNumber;
  String imageURL = '';
  bool loading = false;
  String error = '';
  File _image;
  String _downloadURL = '';

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<UserID>(context);

    StorageService().getProfilePicURL(userID.uid)
    .then((value) {
      setState(() {
        _downloadURL = value;
      });
    })
    .catchError((error) {
      print("Error occured while downloading url $error");
    });

    Future getImage() async {
      final _imagePicker = ImagePicker();
      PickedFile image;

      image = await _imagePicker.getImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image.path);
      });
    }

    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.orange,
                        child: ClipOval(
                          child: new SizedBox(
                            width: 140.0,
                            height: 140.0,
                            child: (_image!=null)?Image.file(
                              _image,
                              fit: BoxFit.fill,
                            ): _downloadURL != "" ? Image.network(
                              _downloadURL,
                              fit: BoxFit.fill,
                            ): Icon(Icons.person, size: 120, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: IconButton(
                        color: Colors.orange,
                        icon: Icon(
                          Icons.camera_alt,
                          size: 30.0,
                        ),
                        onPressed: () async {
                          await getImage();
                        },
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.orange[100],
                  height: 20,
                  thickness: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    initialValue: widget.profileData != null ? widget.profileData['name'] : '',
                    validator: (value) =>
                    value.isEmpty ? "Name can't be empty" : null,
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    decoration: textInputDecorationProfile.copyWith(
                        hintText: "Name"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    initialValue: widget.profileData != null ? widget.profileData['age'].toString() : '',
                    keyboardType: TextInputType.number,
                    validator: (value) => value.isEmpty ? "Age can't be empty" : null,
                    onChanged: (value) {
                      setState(() {
                        age = int.parse(value);
                      });
                    },
                    decoration: textInputDecorationProfile.copyWith(hintText: "Age"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    initialValue: widget.profileData != null ? widget.profileData['mobileNumber'] : '',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        mobileNumber = value;
                      });
                    },
                    decoration: textInputDecorationProfile.copyWith(hintText: "Mobile Number"),
                  ),
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Colors.orange[200];
                          else if (states
                              .contains(MaterialState.disabled))
                            return Colors.orange[200];

                          return Colors
                              .orange; // Use the component's default.
                        },
                      ),
                    ),
                    // style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.orange), ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        loading
                            ? Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                        )
                            : Text(''),
                      ],
                    ),
                    onPressed: loading
                      ? null
                      : () async {
                          setState(() {
                            error = '';
                          });
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            await DatabaseService(uid: userID.uid)
                                .updateUserData(UserData(
                                    uid: userID.uid,
                                    name: name != null ? name : widget.profileData['name'],
                                    age: age != null ? age : widget.profileData['age'],
                                    mobileNumber: mobileNumber != null ? mobileNumber : widget.profileData['mobileNumber'],
                                    todos: []),)
                                .then((value) {
                              final snackBar = SnackBar(
                                content: Text('Profile successfully saved'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              setState(() {
                                loading = false;
                              });
                            }).catchError((error) {
                              final snackBar = SnackBar(
                                content: Text('Failed Saving Profile!'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              setState(() {
                                loading = false;
                              });
                            });

                            if (_image != null) {
                              loading = true;
                              NetworkStatus profilePicUpdateResult = await StorageService().uploadFile(_image, userID.uid);
                              if (profilePicUpdateResult is SuccessState) {
                                setState(() {
                                  loading = false;
                                  error = '';
                                });
                                final snackBar = SnackBar(
                                  content: Text('Profile picture successfully uploaded'),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                setState(() {
                                  loading = false;
                                });
                              } else if (profilePicUpdateResult is ErrorState) {
                                setState(() {
                                  loading = false;
                                  error = "Error occured while updating profile picture";
                                });
                                final snackBar = SnackBar(
                                  content: Text('Failed uploading Profile picture'),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                setState(() {
                                  loading = false;
                                });
                              }
                            }
                          } else {
                            setState(() {
                              loading = false;
                              error = '';
                            });
                          }
                        }),
            ],
            ),
          ),
        ),
    );
  }
}
