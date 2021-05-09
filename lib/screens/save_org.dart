import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:madad/screens/maps.dart';
import 'package:latlong/latlong.dart';
import 'package:madad/service/firebase_service.dart';

class SaveOrg extends StatefulWidget {
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
  // TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text(
                "Add address",
                style: TextStyle(fontSize: 30),
              ),
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
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
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
                var lol = await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyMaps()));
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
                  FirebaseService().addOrganisation(
                      context,
                      nameController.text,
                      emailController.text,
                      contactController.text,
                      geoPoint);
                },
                child: Text('Add address'))
          ],
        ),
      ),
    );
  }
}
