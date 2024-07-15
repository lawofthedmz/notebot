import 'package:flutter/material.dart';
import 'screens/viewprofile.dart';
import 'screens/create.dart';
import 'screens/signin.dart';
import 'screens/home.dart';
import 'screens/upload.dart';
// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Montserrat",
      ),
      // Directly navigate to HomeScreen
      home: SignInScreen(),
      routes: {
        '/signin': (context) => SignInScreen(),
        '/create': (context) => CreateAccountScreen(),
        '/home': (context) => HomeScreen(),
        '/viewprofile': (context) => ViewProfile(),
        '/upload': (context) => UploadScreen(),
        // '/editprofile': (context) => EditProfileScreen(),
      },
    );
  }
}
