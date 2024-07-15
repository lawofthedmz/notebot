import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic here based on the selected index
    switch (index) {
      case 0:
        // Navigate to Home Screen
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        // Navigate to AddNote Screen
        Navigator.pushNamed(context, '/upload');
        break;
      case 2:
        // Navigate to Profile Screen
        Navigator.pushNamed(context, '/viewprofile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
          16.0), //Add margin so it doesn't touch the sides or bottom
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0), // Rounded borders
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            30.0), // Ensure the BottomNavigationBar is clipped within the rounded container
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Color.fromARGB(121, 255, 255, 255),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.control_point_duplicate_sharp),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_outlined),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
