import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:madad/screens/save_org.dart';
import 'package:madad/service/firebase_service.dart';

class Helper {
  // Helper() {
  //   FirebaseService().setCurrentCollection();
  // }

  Position currentPosition;
  var geoLocator = Geolocator();
  static String email = FirebaseAuth.instance.currentUser.email;

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    currentPosition = position;
    print(position);
    return position;
  }

  static AppBar getAppBar(String title) =>
      AppBar(title: Text(title), actions: [Icon(Icons.notifications)]);

  static Scaffold getHomeWidget() {
    return Scaffold(
      body: Column(
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_alert),
      ),
    );
  }

  static Scaffold getProfile(BuildContext context) {
    return Scaffold(
      body: Column(
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
      ),
    );
  }
}
