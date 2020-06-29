// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:Unify/models/user.dart';
import 'package:provider/provider.dart';

class DatabaseService {
  final String uid;
  String data = "";
  DatabaseService({this.uid}); // constructor takes user uniqe id
  // create firebase database object
  final DatabaseReference database =
      FirebaseDatabase.instance.reference().child("users/");

  // set up user (first time registration)
  Future setUPuser() async {
    print("This is user:" + this.uid);
    database.child(this.uid).push().set({
      'IP': 'local_hub',
      'Name': 'Temperature Sensor',
      'State': 0,
      'Type': "S"
    });
  }

  // change Device state
  changeDeviceState(String device) async {
    //check current state
    bool state = false;
    database
        .child(this.uid + "/" + device)
        .once()
        .then((DataSnapshot dataSnapShot) {
      state = dataSnapShot.value["State"] == 1;
    });

    database.child(this.uid).child(device).update({"State": !state});
  }

  // get device state
  Future getDeviceState(String device) async {
    database
        .child(this.uid + "/" + device)
        .once()
        .then((DataSnapshot dataSnapShot) {
      print(dataSnapShot.value["State"]);
    });
  }
}
