import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Lorem Ipson"),
            accountEmail: Text("*********@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: Text(
                "LI",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            // child: Text(
            //   'My Smart Home Menu',
            //   style: TextStyle(color: Colors.white, fontSize: 20),
            // ),
            decoration: BoxDecoration(
                color: Colors.blueAccent[200],
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/livingroom.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
