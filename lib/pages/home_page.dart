import 'package:flutter/material.dart';
import 'package:zoidmail/auth/login_page.dart';
import 'package:zoidmail/pages/Main_page.dart';
import 'package:zoidmail/pages/blogs.dart';
import 'package:zoidmail/pages/contact_us.dart';
import 'package:zoidmail/pages/settings.dart';
import 'package:zoidmail/service/auth_service.dart';
import 'package:zoidmail/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MainPage(),
    BlogPage(),
    ContactUsPage(),
    SettingsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            left: 16, right: 16, bottom: 16), // Space around navbar
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(30), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                blurRadius: 10, // Softness of the shadow
                spreadRadius: 2, // Shadow spread
                offset: Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30), // Ensures rounded edges
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper),
                  label: "Blog",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contact_mail),
                  label: "Contact Us",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Settings",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
