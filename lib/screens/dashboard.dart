import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madad/helper/helper.dart';
import 'package:madad/service/firebase_service.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static Widget widgetToShow;
  static AppBar appbarToShow;
  _DashboardState() {
    // widgetToShow = CustomWidget.getHomeWidget();
  }

  @override
  void initState() {
    // TODO: implement initState
    widgetToShow = Helper.getHomeWidget();
    appbarToShow = Helper.getAppBar("Home");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widgetToShow = Helper.getHomeWidget();
    return Container(
        child: Scaffold(
            appBar: appbarToShow,
            body: DoubleBackToCloseApp(
              child: widgetToShow,
              snackBar: const SnackBar(
                content: Text('Tap back again to leave'),
              ),
            ),
            drawer: drawer()));
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
          setCurrentWidget(Helper.getHomeWidget(), Helper.getAppBar("Home"));
        } else if (title == "Profile") {
          setCurrentWidget(
              Helper.getProfile(context), Helper.getAppBar("Profile"));
        } else if (title == "Logout") {
          FirebaseService.getFirebaseService().logout();
          Navigator.popUntil(
              context, (Route<dynamic> predicate) => predicate.isFirst);
        }
      },
    );
  }

  void setCurrentWidget(Widget widget, AppBar appBar) {
    setState(() {
      widgetToShow = widget;
      appbarToShow = appBar;
    });
  }
}
