import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:madad/screens/main_drawer.dart';
import 'package:madad/screens/maps.dart';
import 'package:latlong/latlong.dart';
import 'package:madad/service/firebase_service.dart';

import 'dashboard.dart';

class SaveOrg extends StatefulWidget {
  var caller;
  SaveOrg(String caller) {
    this.caller = caller;
  }
  @override
  _SaveOrgState createState() => _SaveOrgState();
}

class _SaveOrgState extends State<SaveOrg> {
  _SaveOrgState() {
    Firebase.initializeApp();
  }
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  LatLng result;
  GeoPoint geoPoint;
  String role = "Restaurant";

  // TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add address'),
      ),
      drawer: MainDrawer(),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  ListTile(
                    title: const Text('Restaurant'),
                    leading: Radio<String>(
                      value: "Restaurant",
                      groupValue: role,
                      onChanged: (String value) {
                        setState(() {
                          role = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('SocialService'),
                    leading: Radio<String>(
                      value: "SocialService",
                      groupValue: role,
                      onChanged: (String value) {
                        setState(() {
                          role = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                height: 50,
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: contactController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contact',
                  ),
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        child: Builder(
                          builder: (context) {
                            if (result != null) {
                              return Text('${result.latitude.toString()}');
                            } else {
                              return Text('Latitude');
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Builder(
                          builder: (context) {
                            if (result != null) {
                              return Text('${result.longitude.toString()}');
                            } else {
                              return Text('Longitude');
                            }
                          },
                        ),
                      ),
                    ],
                  )),
              TextButton(
                child: Text('Add location on map'),
                onPressed: () async {
                  var lol = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyMaps()));
                  setState(() {
                    result = lol;
                    geoPoint = GeoPoint(result.latitude, result.longitude);
                  });
                },
              ),
              TextButton(
                  onPressed: () {
                    print(geoPoint.latitude.toString());
                    print(result.latitude.toString());
                    FirebaseService.getFirebaseService().addOrganisation(
                        context,
                        nameController.text,
                        role,
                        contactController.text,
                        geoPoint);
                    if (widget.caller == "ProfilePage") {
                      Navigator.pop(context);
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Dashboard()));
                    }
                  },
                  child: Text('Add address'))
            ],
          ),
        ),
      ),
    );
  }
}
