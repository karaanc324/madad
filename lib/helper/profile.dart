import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madad/screens/save_org.dart';
import 'package:madad/service/firebase_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
            stream: FirebaseService.getFirebaseService().getProfile(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            snapshot.data.get("name"),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            snapshot.data.get("email"),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            snapshot.data.get("contact"),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            snapshot.data.get("geo").latitude.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            snapshot.data.get("geo").longitude.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SaveOrg("ProfilePage")));
            },
            child: Text('Edit Profile'))
      ],
    );
  }
}
