import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:todo_app/screens/common/utils.dart';
import 'package:todo_app/service/firebase/database/database_service.dart';
import 'package:todo_app/service/modals/todo.dart';
import 'package:todo_app/service/modals/user.dart';
import 'package:provider/provider.dart';

class AddTODOBottomSheet extends StatefulWidget {
  @override
  _AddTODOBottomSheetState createState() => _AddTODOBottomSheetState();
}

class _AddTODOBottomSheetState extends State<AddTODOBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  String _task;
  bool loading = false;
  int _dueDate = DateTime.now().millisecondsSinceEpoch;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.fromMillisecondsSinceEpoch(_dueDate),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked.millisecondsSinceEpoch != _dueDate)
      setState(() {
        _dueDate = picked.millisecondsSinceEpoch;
      });
  }

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<UserID>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Task",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    validator: (value) =>
                    value.isEmpty ? "Task can't be empty" : null,
                    onChanged: (value) {
                      setState(() {
                        _task = value;
                      });
                    },
                    decoration: textInputDecorationLoginForms,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Select Due Date",

                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 2),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text("${DateTime.fromMillisecondsSinceEpoch(_dueDate).toLocal()}".split(' ')[0]),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select date'),
                    ),
                  ],
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
                          'Add',
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
                      if (_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        await DatabaseService(uid: userID.uid).updateUserTODOs(TODO(task: _task, dueDate: _dueDate))
                            .then((value) {
                          final snackBar = SnackBar(
                            content: Text('TODO successfully saved'),
                          );
                          setState(() {
                            loading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        })
                            .catchError((error) {
                          final snackBar = SnackBar(
                            content: Text('Failed to save TODO'),
                          );
                          setState(() {
                            loading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          loading = false;
                        });
                      }
                    }),
              ],
            ),
          )
      ),
    );
  }
}
