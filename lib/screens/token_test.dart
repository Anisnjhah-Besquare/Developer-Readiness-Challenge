import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:drc/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  AddNote({this.apiToken, this.email});
  String? apiToken;
  String? email;

  @override
  _AddNoteState createState() =>
      _AddNoteState(apiToken: apiToken, email: email);
}

class _AddNoteState extends State<AddNote> {
  _AddNoteState({this.apiToken, this.email});

  String field_Name = 'abcdefu';
  String? apiToken;
  String? email;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Add in token",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      content: Center(
          child: Column(children: [
        Text('Enter the BeRad app API token for "$email".',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Card(
          color: Colors.transparent,
          elevation: 0.0,
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (_val) {
                  field_Name = _val;
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter token",
                  filled: true,
                  fillColor: Color(0xFFF4F4F4),
                ),
              ),
            ],
          ),
        ),
      ])),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            AuthHelper().logOut();

            // FirebaseAuth.instance.signOut();
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => LoginScreen(),
            //   ),
            // );
          },
          child: const Text("Cancel", style: TextStyle(fontSize: 17)),
        ),
        TextButton(
          onPressed: () {
            String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
            RegExp regExp = new RegExp(pattern);
            print(field_Name.length);
            (validator(field_Name.toString()))
                ? showDialog(
                    context: context,
                    builder: (BuildContext ctxt) {
                      return AlertDialog(
                        title:
                            Text("Are you sure you want to change API Token ?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(ctxt).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Confirm"),
                            onPressed: () {
                              saveAPI();
                              Navigator.of(ctxt).pop();

                              // Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  )
                : showDialog(
                    context: context,
                    builder: (BuildContext ctxt) {
                      return AlertDialog(
                        title: Text(
                            "API Token must be alphanumeric with less than 20 characters and cannot be empty.",
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        actions: <Widget>[
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(ctxt).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
          },
          child: const Text("Verify", style: TextStyle(fontSize: 17)),
        ),
      ],
    );
  }

  void saveAPI() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes')
        .add({
      'token': field_Name,
      'created': DateTime.now(),
    });
    // save to db
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Token Added Successfully'),
          actions: <Widget>[
            TextButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool validator(String value) {
    if (value.length > 20) {
      return false;
    } else if (value.isNotEmpty) {
      bool mobileValid = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
      return mobileValid;
    }

    return false;
  }
}
