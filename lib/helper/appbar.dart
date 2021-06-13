import 'package:flutter/material.dart';
import 'package:madad/service/firebase_service.dart';
import 'package:provider/provider.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  MyAppbar(String title) {
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    var lol = Provider.of<FirebaseService>(context).getCounter();
    return AppBar(title: Text(title), actions: [
      // Consumer<FirebaseService>(
      //   builder: (_, firebaseService, __) {
      Stack(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                print("====================");
                // print(
                // Provider.of<FirebaseService>(context).notificationCounter);
                // firebaseService.notificationCounter = 0;
                Provider.of<FirebaseService>(context, listen: false)
                    .resetCounter();
              }),
          new Positioned(
            right: 11,
            top: 11,
            child: new Container(
              padding: EdgeInsets.all(2),
              decoration: new BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 14,
                minHeight: 14,
              ),
              child: Text(
                '$lol',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // : new Container()
        ],
      )
      // },
      // ),
    ]);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
