import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class FirebaseService {
  FirebaseService() {
    Firebase.initializeApp();
  }

  Future addOrganisation(BuildContext context, String name, String email,
      String contact, GeoPoint latLng) async {
    await FirebaseFirestore.instance
        .collection("social_service_org")
        .add({"name": name, "email": email, "contact": contact, "geo": latLng});
  }
}
