import 'package:flutter/material.dart';
import 'screens/create.dart';
import 'screens/signin.dart';
import 'screens/home.dart';
import 'screens/test.dart'; // Import the TestScreen

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      // Set the initial route to TestScreen for testing
      home: TestScreen(),
      routes: {
        '/signin': (context) => SignInScreen(),
        '/create': (context) => CreateAccountScreen(),
        '/home': (context) => HomeScreen(),
        '/test': (context) => TestScreen(), // Add TestScreen to routes
      },
    );
  }
}
