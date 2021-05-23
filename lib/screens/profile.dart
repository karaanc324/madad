import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:madad/screens/main_drawer.dart';
import 'package:madad/screens/save_org.dart';
import 'package:madad/service/firebase_service.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String email = FirebaseAuth.instance.currentUser.email;
  @override
  void initState() {
    Firebase.initializeApp();
    // TODO: implement initState
    super.initState();
    print("00000000000000000000");
    print(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          StreamBuilder(
              // stream: FirebaseService().getAllSocialService(),
              stream: FirebaseFirestore.instance
                  .collection("social_service_org")
                  .doc(email)
                  .snapshots(),
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
      ),
    );
  }
}
