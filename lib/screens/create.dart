import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF712A89), Color(0xFF140609)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // SVG Overlay
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/background.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Page Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'NoteBot',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Enter your email to sign up and create a password.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.0),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'email@domain.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle sign up with email
                  },
                  child: Text('Sign up with email',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                      )
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.white),),
                    Padding(padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'or continue with',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white,)),
                  ],
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Add padding to separate the buttons
                  child: SizedBox(
                    height: 50.0, // Set a fixed height for all buttons
                    child: SignInButton(
                      Buttons.Google,
                      text: "Sign up with Google",
                      onPressed: () {
                        // Handle Google sign up
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Add padding to separate the buttons
                  child: SizedBox(
                    height: 50.0, // Set a fixed height for all buttons
                    child: SignInButton(
                      Buttons.Facebook,
                      text: "Sign up with Meta",
                      onPressed: () {
                        // Handle Meta sign up
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Add padding to separate the buttons
                  child: SizedBox(
                    height: 50.0, // Set a fixed height for all buttons
                    child: SignInButton(
                      Buttons.GitHub,
                      text: "Sign up with GitHub",
                      onPressed: () {
                        // Handle GitHub sign up
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

