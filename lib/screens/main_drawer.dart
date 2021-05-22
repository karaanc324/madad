import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madad/screens/home.dart';
import 'package:madad/screens/profile.dart';
import 'package:madad/screens/save_org.dart';
import 'package:madad/service/firebase_service.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer() {
    var email = FirebaseAuth.instance.currentUser.email;
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          color: Colors.blue,
          child: Center(child: Text(FirebaseAuth.instance.currentUser.email)),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            'Home',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          onTap: () {
            Navigator.pop(context, true);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Profile()));
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text(
            'Logout',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          onTap: () {
            FirebaseService().logout();
            Navigator.popUntil(
                context, (Route<dynamic> predicate) => predicate.isFirst);
          },
        ),
      ],
    ));
  }
}
