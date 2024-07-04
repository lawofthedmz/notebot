import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note_bot/screens/sidebar.dart';

class ViewProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(
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
          // SearchBarModule(),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                SizedBox(height:MediaQuery.of(context).size.height, child: Sidebar()),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        
                        children: [
                          Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                      
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(63.0),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 87.5,
                                                  child: Text('JD'),
                                                ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:18.0),
                                      child: Text("Edit profile image", style: TextStyle(color: Color.fromARGB(255, 13, 153, 255)),),
                                    ),

                                  ],
                                  
                                ),
                              ),
                              Text("Hi, I'm JD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 64.0, color: Colors.white),)
                            ],
                          ),
                        Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                      
                            children: [
                              Text("Email", style: TextStyle(fontSize: 20.0, color: Colors.white)),
                              Padding(
                                padding: const EdgeInsets.only(left:200.0),
                                child: Text("name@domain.com",style: TextStyle(fontSize: 20.0, color: Colors.white),),
                              )
                            ],
                          ),
                       Padding(
                         padding: const EdgeInsets.only(top: 53.0),
                         child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                               
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15.5),
                                  decoration: BoxDecoration(                                color: Color.fromARGB(127, 0, 0, 0),
                                borderRadius: BorderRadius.circular(50)),
                                  child: Text("Change Password", style: TextStyle(fontSize: 20.0, color: Colors.white)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 200.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(15.5),
                                    decoration: BoxDecoration(                                color: Color.fromARGB(127, 0, 0, 0),
                                                           borderRadius: BorderRadius.circular(50)),
                                    child: Text("Logout",style: TextStyle(fontSize: 20.0, color: Colors.white),),
                                  ),
                                )
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
          ),
              ]
              )
              );
        

  }
}