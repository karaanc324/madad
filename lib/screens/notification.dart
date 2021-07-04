import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madad/helper/appbar.dart';
import 'package:madad/screens/notification_tile.dart';
import 'package:madad/service/firebase_service.dart';

class MyNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("NOTIFICATION"),
        ),
        body: Container(
            child: StreamBuilder(
          stream: FirebaseService().getNotification(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.data() == null
                      ? 0
                      : snapshot.data.data().entries.elementAt(0).value.length,
                  itemBuilder: (context, int i) {
                    return Container(
                        // child: Text(snapshot.data.data().toString()),
                        child: ListTile(
                      onTap: () {
                        print(snapshot.data
                            .data()
                            .entries
                            .elementAt(0)
                            .value[i]
                            // ["sender"]
                            // .key
                            .toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationTile(snapshot
                                        .data
                                        .data()
                                        .entries
                                        .elementAt(0)
                                        .value[i]
                                    // ["sender"]
                                    // .key
                                    )));
                      },
                      title: Text(snapshot.data
                          .data()
                          .entries
                          .elementAt(0)
                          .value[i]["sender"]
                          // .key
                          .toString()),
                    ));
                  });
            } else {
              return CircularProgressIndicator();
            }
          },
        )));
  }
}
