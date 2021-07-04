import 'dart:io';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madad/helper/appbar.dart';
import 'package:madad/helper/homepage.dart';
import 'package:madad/helper/profile.dart';
import 'package:madad/screens/request.dart';
import 'package:madad/service/firebase_service.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static Widget widgetToShow;
  static PreferredSizeWidget appbarToShow;
  _DashboardState() {
    // widgetToShow = CustomWidget.getHomeWidget();
  }

  @override
  void initState() {
    // FirebaseService.getFirebaseService().setCurrentUser();
    FirebaseService.getFirebaseService().registerOnFirebase();
    // sleep(Duration(seconds: 5));
    Provider.of<FirebaseService>(context, listen: false).incrementCounter();
    widgetToShow = MyHomepage();
    appbarToShow = MyAppbar("HOME");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lol = Provider.of<FirebaseService>(context).getCounter();
    return Scaffold(
        appBar: appbarToShow,
        body: widgetToShow,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_alert),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SendRequest()));
          },
        ),
        drawer: drawer());
  }

  drawer() {
    return Drawer(
        child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          color: Colors.greenAccent,
          child: Center(
              child: Text(
            FirebaseAuth.instance.currentUser.email,
            style: TextStyle(color: Colors.black),
          )),
        ),
        getListTile("Home", Icon(Icons.home)),
        getListTile("Profile", Icon(Icons.person)),
        getListTile("Settings", Icon(Icons.settings)),
        getListTile("Logout", Icon(Icons.logout)),
      ],
    ));
  }

  getListTile(String title, Icon icon) {
    return ListTile(
      leading: icon,
      title: Text(title, style: TextStyle(fontSize: 18)),
      onTap: () {
        Navigator.pop(context);
        if (title == "Home") {
          setCurrentWidget(MyHomepage(), MyAppbar("HOME"));
        } else if (title == "Profile") {
          setCurrentWidget(ProfilePage(), MyAppbar("PROFILE"));
        } else if (title == "Logout") {
          FirebaseService.getFirebaseService().logout();
          Navigator.popUntil(
              context, (Route<dynamic> predicate) => predicate.isFirst);
        }
      },
    );
  }

  void setCurrentWidget(Widget widget, PreferredSizeWidget appBar) {
    setState(() {
      widgetToShow = widget;
      appbarToShow = appBar;
    });
  }
}
