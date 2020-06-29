import 'package:flutter/material.dart';
import 'package:Unify/models/user.dart';
import 'package:Unify/screens/wrapper.dart'; //import flutter package
import 'package:Unify/services/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp()); //main loop
}

// CLASSES

// Create a class that inherit from the flutter Stateless class
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user, child: MaterialApp(home: Wrapper()));
  }
}
