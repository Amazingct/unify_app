import 'package:flutter/material.dart';
import 'package:Unify/services/auth.dart';
import 'package:Unify/services/database.dart';
import 'package:provider/provider.dart';
import 'package:Unify/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import "dart:convert";

// user unique id is what is used to identify table on real time db (the variable holding that is user.uid)

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State {
  final AuthService _auth = AuthService();
  dynamic db;
  dynamic tags = [];
  dynamic names = [];
  dynamic type = [];
  dynamic state = [];
  int fresh = 1;
  final DatabaseReference database =
      FirebaseDatabase.instance.reference().child("users/");

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    DatabaseService userdb = DatabaseService(uid: user.uid);

    final DatabaseReference database =
        FirebaseDatabase.instance.reference().child("users/");

    // remenber the builf function is like a loop, so this if statement ensures the database is read once
    if (fresh == 1) {
      database.child(user.uid + "/").once().then((DataSnapshot dataSnapShot) {
        setState(() {
          db = dataSnapShot.value;
          print(db);
          // put names and tag in list

          db.forEach((k, v) {
            tags.add(k);
            names.add(v["Name"]);
            type.add(v["Type"]);
            state.add(v["State"]);
          });
        });
        print(state);
        print(names);
      });
      fresh = 0;
    } else {}

    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text("Your Devices"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text("logout"),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
        // Mian home content
        body: Column(children: <Widget>[
          // devices control interface
          Container(
            child: Column(children: [
              for (var i = 0; i < names.length; i++)
                Row(
                  children: [
                    RaisedButton(
                        color: Colors.blue[400],
                        child: Text(names[i].toString()),
                        onPressed: () async {
                          // if it is a toggle device
                          if (type[i] == 'T') {
                            setState(() {
                              state[i] = !state[i];
                            });
                            print(state);
                            print(names);

                            // Now this is where we sync states to firebase

                            database
                                .child(user.uid)
                                .child(tags[i])
                                .update({"State": state[i]});
                          }
                          // if it a sensor device
                          if (type[i] == 'S') {
                            database
                                .child(user.uid + "/")
                                .once()
                                .then((DataSnapshot dataSnapShot) {
                              setState(() {
                                db = dataSnapShot.value;
                                // update sensor state
                                state[i] = db[tags[i]]["State"];
                              });
                              print(state);
                              print(names);
                            });
                          }

                          // if it is a regulator device
                          if (type[i] == 'R') {
                            setState(() {
                              // increment state by 1
                              if (state[i] < 5) state[i] = state[i] + 1;
                              if (state[i] == 5) state[i] = 0;
                              database
                                  .child(user.uid)
                                  .child(tags[i])
                                  .update({"State": state[i]});
                            });
                          }
                        }),
                    Text("      " + state[i].toString())
                  ],
                )
            ]),
          )
        ]));
  }
}
