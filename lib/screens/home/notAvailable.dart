import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

Widget _buildAboutDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Oops'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildLogoAttribution(),
      ],
    ),
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

Widget _buildLogoAttribution() {
  return new Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: new Row(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: new Image.asset(
            "assets/flutter.png",
            width: 32.0,
          ),
        ),
        const Expanded(
          child: const Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: const Text(
              'So sorry, Your response can not be carried out, Our developers are working on this Section to give you seamless Experience.',
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
        ),
      ],
    ),
  );
}
