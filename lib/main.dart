import 'package:flutter/material.dart';
import 'screens/create.dart';
import 'screens/signin.dart';
import 'screens/home.dart';

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
      // Use StreamBuilder to determine the initial route
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // User is logged in, navigate to HomeScreen
            return HomeScreen();
          } else {
            // User is not logged in, navigate to CreateAccountScreen
            return SignInScreen();
          }
        },
      ),
      routes: {
        '/signin': (context) => SignInScreen(),
        '/create': (context) => CreateAccountScreen(),
        '/home': (context) => HomeScreen(),
        // '/editprofile': (context) => EditProfileScreen(),
      },
    );
  }
}
