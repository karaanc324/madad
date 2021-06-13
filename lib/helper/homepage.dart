import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madad/service/firebase_service.dart';

class MyHomepage extends StatelessWidget {
  const MyHomepage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
            stream: FirebaseService.getFirebaseService().getRoleList(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.size,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      // color: Colors.grey,
                      child: Text(
                        snapshot.data.docs[index]["name"],
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            })
      ],
    );
  }
}
