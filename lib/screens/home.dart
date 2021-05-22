import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:madad/screens/main_drawer.dart';
import 'package:madad/service/firebase_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String email = FirebaseAuth.instance.currentUser.email;
  String role;
  var snap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          StreamBuilder(
              // stream: FirebaseService().getAllSocialService(),
              stream: snap,
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

  getList() async {
    // String roleToGet = getRoles() as String;
    // return FirebaseService().getRoles(roleToGet);
    Stream<QuerySnapshot> lol;

    await getRoles().then((value) => {lol = value});
    print("55555555555555555555 $lol");
    // return lol;
    setState(() {
      snap = lol;
    });
  }

  getRoles() async {
    var role;
    await FirebaseService()
        .getRoleToDisplay(email)
        .then((value) => {role = FirebaseService().getRoleList(value)});
    print("888888888888888888888888 $role");
    return role;
  }
}