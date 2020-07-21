import 'package:Unify/screens/home/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class SendEmail extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  _sendEmail() async {
    final String _email = 'mailto:unifyhas@gmail.com' +
        _emailController.text +
        '?subject=' +
        _subjectController.text +
        '&body=' +
        _bodyController.text;
    try {
      await launch(_email);
    } catch (e) {
      throw 'Could not Send the Email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 12),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new Home();
                }));
              },
            ),
          ),
          title: Text('Contact us')),
      body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.92,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  TextField(
                    controller: _subjectController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Subject',
                    ),
                  ),
                  TextField(
                    controller: _bodyController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Message',
                    ),
                  ),
                  Text("  "),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.blue[400],
                    child: Text('Send Email',
                        style: TextStyle(
                            fontFamily: 'Roboto', color: Colors.white)),
                    onPressed: _sendEmail,
                  ),
                ],
              ))),
    );
  }
}
