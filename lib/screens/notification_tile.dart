import 'package:flutter/material.dart';
import 'package:madad/service/firebase_service.dart';

class NotificationTile extends StatelessWidget {
  // const NotificationTile({Key key}) : super(key: key);
  var obj;
  NotificationTile(var obj) {
    this.obj = obj;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification tile'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            if (obj['type'] != null) Text(obj["type"].toString()),
            if (obj['sender'] != null) Text(obj["sender"].toString()),
            if (obj['total-req'] != null) Text(obj["total-req"].toString()),
            if (obj["age"] != null) Text(obj["age"].toString()),
            if (obj["email"] != null) Text(obj["email"].toString()),
            if (obj["accept"] != null) Text(obj["accept"].toString()),
            TextButton(
                onPressed: () {
                  print("lol${obj["email"].toString()}");
                  FirebaseService.getFirebaseService()
                      .sendAcceptNotification(obj["email"].toString());
                },
                child: Text("Accept")),
          ],
        ),
      ),
    );
  }
}
