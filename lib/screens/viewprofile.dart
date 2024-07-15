import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note_bot/screens/bottomnavbar.dart';
import 'package:note_bot/screens/sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar:
          MediaQuery.of(context).size.width < 800 ? BottomNavBar() : null,
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
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 800) {
                return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Row(
                    children: <Widget>[
                      SizedBox(height: constraints.maxHeight, child: Sidebar()),
                      Expanded(
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(63.0),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 87.5,
                                            child: Text(user?.displayName
                                                    ?.substring(0, 2)
                                                    .toUpperCase() ??
                                                'JD'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18.0),
                                            child: Text(
                                              "Edit profile image",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 13, 153, 255)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "Hi, I'm ${user?.displayName ?? 'JD'}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 64.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 124.0),
                                      child: Text("Email",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white)),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 200.0),
                                      child: Text(
                                        user?.email ?? 'name@domain.com',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 53.0, left: 50.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(15.5),
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(127, 0, 0, 0),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Text("Change Password",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 200.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            Navigator.pushReplacementNamed(
                                                context, '/signin');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(15.5),
                                            decoration: BoxDecoration(
                                              color:
                                                  Color.fromARGB(127, 0, 0, 0),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Text("Logout",
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30.0),
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.white))),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Profile",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: CircleAvatar(
                          radius: 32,
                          child: Text(user?.displayName
                                  ?.substring(0, 2)
                                  .toUpperCase() ??
                              'JD'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          "Edit profile image",
                          style: TextStyle(
                              color: Color.fromARGB(255, 13, 153, 255),
                              fontSize: 20.0),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 46.0),
                            child: Text("Email",
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, top: 46.0),
                            child: Text(user?.email ?? 'name@domain.com',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 53.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15.5),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(127, 0, 0, 0),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text("Change Password",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: GestureDetector(
                                onTap: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacementNamed(
                                      context, '/signin');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15.5),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(127, 0, 0, 0),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text("Logout",
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.white)),
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
            },
          ),
        ],
      ),
    );
  }
}
