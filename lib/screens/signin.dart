import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

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
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // Wide layout: show side-by-side
                return Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Text(
                                'NoteBot',
                                style: TextStyle(
                                  fontSize: 64.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 32.0),
                              child: Text(
                                'Take notes on the fly, anytime, anywhere',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Enter your email to sign in.',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Montserrat',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              SizedBox(height: 24.0),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'email@domain.com',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 16.0),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Password...',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      // Sign in with email and password
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim(),
                                      );
                                      // Navigate to HomeScreen after successful sign in
                                      Navigator.pushReplacementNamed(
                                          context, '/home');
                                    } catch (e) {
                                      // Handle sign in errors (e.g., wrong password, user not found)
                                      print(
                                          'Error signing in: ${e.toString()}');
                                      setState(() {
                                        _errorMessage =
                                            'Incorrect email or password';
                                      });
                                    }
                                  }
                                },
                                child: Text(
                                  'Sign in with email',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                  ),
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
                                    child: Divider(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'or continue with',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: SizedBox(
                                  height: 50.0,
                                  child: SignInButton(
                                    Buttons.Google,
                                    text: "Sign in with Google",
                                    onPressed: () async {
                                      try {
                                        // Sign in with Google
                                        await FirebaseAuth.instance
                                            .signInWithPopup(
                                          GoogleAuthProvider(),
                                        );
                                        // Navigate to HomeScreen after successful Google sign in
                                        Navigator.pushReplacementNamed(
                                            context, '/home');
                                      } catch (e) {
                                        // Handle Google sign in errors
                                        print(
                                            'Error signing in with Google: ${e.toString()}');
                                        setState(() {
                                          _errorMessage =
                                              'Failed to sign in with Google';
                                        });
                                      }
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: SizedBox(
                                  height: 50.0,
                                  child: SignInButton(
                                    Buttons.GitHub,
                                    text: "Sign in with GitHub",
                                    onPressed: () async {
                                      try {
                                        // Sign in with GitHub
                                        await FirebaseAuth.instance
                                            .signInWithPopup(
                                          GithubAuthProvider(),
                                        );
                                        // Navigate to HomeScreen after successful GitHub sign in
                                        Navigator.pushReplacementNamed(
                                            context, '/home');
                                      } catch (e) {
                                        // Handle GitHub sign in errors
                                        print(
                                            'Error signing in with GitHub: ${e.toString()}');
                                        setState(() {
                                          _errorMessage =
                                              'Failed to sign in with GitHub';
                                        });
                                      }
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
                                  Navigator.pushNamed(context, '/create');
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Need to make an account? ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Create Account',
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
                      ),
                    ),
                  ],
                );
              } else {
                // Narrow layout: show vertically
                return SingleChildScrollView(
                  child: Padding(
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
                          'Sign In',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Enter your email to sign in.',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'Montserrat',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        SizedBox(height: 24.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'email@domain.com',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Password...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                // Sign in with email and password
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                                // Navigate to HomeScreen after successful sign in
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              } catch (e) {
                                // Handle sign in errors (e.g., wrong password, user not found)
                                print('Error signing in: ${e.toString()}');
                                setState(() {
                                  _errorMessage = 'Incorrect email or password';
                                });
                              }
                            }
                          },
                          child: Text(
                            'Sign in with email',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            ),
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
                              child: Divider(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'or continue with',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            height: 50.0,
                            child: SignInButton(
                              Buttons.Google,
                              text: "Sign in with Google",
                              onPressed: () async {
                                try {
                                  // Sign in with Google
                                  await FirebaseAuth.instance.signInWithPopup(
                                    GoogleAuthProvider(),
                                  );
                                  // Navigate to HomeScreen after successful Google sign in
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                } catch (e) {
                                  // Handle Google sign in errors
                                  print(
                                      'Error signing in with Google: ${e.toString()}');
                                  setState(() {
                                    _errorMessage =
                                        'Failed to sign in with Google';
                                  });
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            height: 50.0,
                            child: SignInButton(
                              Buttons.GitHub,
                              text: "Sign in with GitHub",
                              onPressed: () async {
                                try {
                                  // Sign in with GitHub
                                  await FirebaseAuth.instance.signInWithPopup(
                                    GithubAuthProvider(),
                                  );
                                  // Navigate to HomeScreen after successful GitHub sign in
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                } catch (e) {
                                  // Handle GitHub sign in errors
                                  print(
                                      'Error signing in with GitHub: ${e.toString()}');
                                  setState(() {
                                    _errorMessage =
                                        'Failed to sign in with GitHub';
                                  });
                                }
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
                            Navigator.pushNamed(context, '/create');
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Need to make an account? ',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                              ),
                              children: [
                                TextSpan(
                                  text: 'Create Account',
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
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
