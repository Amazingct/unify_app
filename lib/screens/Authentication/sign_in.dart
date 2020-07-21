import 'package:flutter/material.dart';
import 'package:Unify/services/auth.dart';
import 'package:Unify/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  // text filed states
  String email = "";
  String password = "";
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue[400],
              elevation: 0.0,
              title: Text("Sign in to Unify"),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text("Register"))
              ],
            ),
            body: Container(
              margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: new SingleChildScrollView(
                  child: Column(children: [
                Text("Unify",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[400])),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: "Email"),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(hintText: "password"),
                        obscureText: true,
                        /*
                        validator: (val) => val.length < 6
                            ? 'Enter a valid password (6+ characters)'
                            : null, */
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.blue[400],
                        child: Text("Sign in",
                            style: TextStyle(
                                fontFamily: 'Roboto', color: Colors.white)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);

                            if (result == null) {
                              setState(() {
                                error = "could not sign in, try again";
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      // reset password button
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.blue[400],
                        child: Text("Reset Password",
                            style: TextStyle(
                                fontFamily: 'Roboto', color: Colors.white)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth.forgetPassword(email);

                            if (result == null) {
                              setState(() {
                                error = "error reset password";
                                loading = false;
                              });
                            } else {
                              error = "Reset link sent to email address";
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                )
              ])),
            ));
  }
}
