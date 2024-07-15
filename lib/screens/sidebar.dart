import 'package:flutter/material.dart';
import 'package:note_bot/screens/home.dart';
import 'package:note_bot/screens/viewprofile.dart';
import 'package:note_bot/screens/upload.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'John Doe'),
            accountEmail: Text(user?.email ?? 'john.doe@example.com'),
            currentAccountPicture: CircleAvatar(
              child: Text(
                  user?.displayName?.substring(0, 2).toUpperCase() ?? 'JD'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            selected: _selectedIndex == 0,
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            selected: _selectedIndex == 1,
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ViewProfile()));
            },
          ),
          ListTile(
            leading: Icon(Icons.upload_file),
            title: Text('Upload'),
            selected: _selectedIndex == 2,
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UploadScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
        ],
      ),
    );
  }
}
