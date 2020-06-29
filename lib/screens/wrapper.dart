import 'package:flutter/material.dart';
import 'package:Unify/screens/Authentication/authenticate.dart';
import 'package:Unify/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:Unify/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      // String uid = user.uid;
      return Home();
    }
  }
}
