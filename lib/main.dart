import 'package:flutter/material.dart';
import 'screens/create.dart';
import 'screens/signin.dart';
import 'screens/home.dart';
import 'screens/viewprofile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CreateAccountScreen(),
        '/signin': (context) => SignInScreen(),
        '/create': (context) => CreateAccountScreen(),
        // '/home': (context) => HomeScreen(),
        // '/editprofile': (context) => EditProfileScreen(),
      },
    );
  }
}
