import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:madad/screens/home.dart';
import 'package:madad/screens/main_drawer.dart';
import 'package:madad/screens/save_org.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            body: DoubleBackToCloseApp(
              child: Home(),
              snackBar: const SnackBar(
                content: Text('Tap back again to leave'),
              ),
            ),
            drawer: MainDrawer()));
  }
}
