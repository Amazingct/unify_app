import 'package:flutter/material.dart';
import 'package:Unify/services/auth.dart';
import 'package:Unify/services/database.dart';
import 'package:provider/provider.dart';
import 'package:Unify/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import "dart:convert";
import 'package:intl/intl.dart';
import 'package:Unify/screens/home/contactUs.dart';
import 'package:Unify/screens/home/menu.dart';
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
  int heighte = 150;
  bool _isEditingText = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController _editingController;
  String initialText = "Living Room";
  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

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

    Widget _buildAboutDialog(BuildContext context) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        title: const Text('Oops'),
        content: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: const Text(
                  'So sorry, Your response can not be carried out, Our developers are working on this Section to give you seamless Experience.',
                  style: const TextStyle(fontSize: 12.0),
                ),
              ),
            ]),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Okay, got it!'),
          ),
        ],
      );
    }

    Widget _editTitleTextField(BuildContext context) {
      //if (_isEditingText)
      return new Scaffold(
          body: Center(
              child: Column(children: [
        Container(
            margin: EdgeInsets.all(20),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Rename Room',
              ),
              onChanged: (text) {
                setState(() {
                  initialText = text;
                  //you can access nameController in its scope to get
                  // the value of text entered as shown below
                  //fullName = nameController.text;
                });
              },
            )),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Okay, got it!'),
        ),
      ])));
    }

    return Scaffold(
      backgroundColor: Colors.brown[50],
      drawer: NavDrawer(),
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 12),
          child: IconButton(
              icon: Icon(Icons.menu, color: Colors.black54),
              onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        title: Text("My Devices",
            style: TextStyle(fontFamily: 'Roboto', color: Colors.black54)),
        backgroundColor: Colors.grey[200],
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
      body: Center(
          child: Column(children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width * 0.92,
                  color: Colors.transparent,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent[200],
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Row(children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "" + state[names.indexOf('Temperature')].toString() + "°C",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: (heighte * 0.35)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          '',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: (heighte * 0.05)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      new Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                            new Text(
                              "${(DateTime.now().hour)}:${(DateTime.now().minute)} ",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontSize: (heighte * 0.20)),
                              textAlign: TextAlign.center,
                            ),
                            new Text(
                              "${DateFormat.yMMMMEEEEd().format(DateTime.now())}",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontSize: (heighte * 0.12)),
                              textAlign: TextAlign.center,
                            ),
                          ])),
                    ]),
                  ),
                )
              ]),
        ),
        // devices control interface

        Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            // height: MediaQuery.of(context).size.height * 0.18,
            width: MediaQuery.of(context).size.width * 0.92,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              // gradient: LinearGradient(
              //   colors: [Colors.purple, Colors.purpleAccent],
              // ),
              image: DecorationImage(
                  image: AssetImage('assets/images/livingroom1.jpg'),
                  fit: BoxFit.cover),

              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                ),
              ],
            ),
            child: Column(children: [
              Row(children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    initialText,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: (heighte * 0.15)),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 15.0),
                GestureDetector(
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _editTitleTextField(context),
                    );
                  },
                )
              ]),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 15),
                child: Column(children: [
                  for (var i = 0; i < names.length; i++)
                    Row(
                      children: [
                        RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            color: Colors.blue[400],
                            child: Text(names[i].toString(),
                                style: TextStyle(
                                    fontFamily: 'Roboto', color: Colors.white)),
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
                        Container(
                            color: Colors.grey.withOpacity(0.5),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "      " + state[i].toString(),
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )))
                      ],
                    )
                ]),
              )
            ]))
      ])),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildAboutDialog(context),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[150],
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new SendEmail();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
