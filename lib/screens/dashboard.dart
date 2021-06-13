import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madad/helper/appbar.dart';
import 'package:madad/helper/homepage.dart';
import 'package:madad/helper/profile.dart';
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
    // FirebaseService().registerOnFirebase();
    // Provider.of<FirebaseService>(context, listen: false).incrementCounter();
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
            // print("lol");
            print(FirebaseService.getFirebaseService().notificationCounter);
            FirebaseService.getFirebaseService().notificationCounter++;
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

// class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
//   String title;
//   MyAppbar(String title) {
//     this.title = title;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(title: Text(title), actions: [
//       // Consumer<FirebaseService>(
//       //   builder: (_, firebaseService, __) {
//       Stack(
//         children: <Widget>[
//           IconButton(
//               icon: Icon(Icons.notifications),
//               onPressed: () {
//                 print("====================");
//                 print(
//                     Provider.of<FirebaseService>(context).notificationCounter);
//                 // firebaseService.notificationCounter = 0;
//                 Provider.of<FirebaseService>(context).resetCounter();
//               }),
//           new Positioned(
//             right: 11,
//             top: 11,
//             child: new Container(
//               padding: EdgeInsets.all(2),
//               decoration: new BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               constraints: BoxConstraints(
//                 minWidth: 14,
//                 minHeight: 14,
//               ),
//               child: Text(
//                 '${Provider.of<FirebaseService>(context).getCounter()}',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 8,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//           // : new Container()
//         ],
//       )
//       // },
//       // ),
//     ]);
//   }

//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => throw UnimplementedError();
// }
