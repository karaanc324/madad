import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseService {
  String email;
  String collection;
  String currentCollection;
  String otherCollection;
  static FirebaseService firebaseService;
  FirebaseService() {
    Firebase.initializeApp();
  }

  static getFirebaseService() {
    if (firebaseService == null) {
      firebaseService = FirebaseService();
    }
    return firebaseService;
  }

  Future addOrganisation(BuildContext context, String name, String role,
      String contact, GeoPoint latLng) async {
    email = FirebaseAuth.instance.currentUser.email;
    await FirebaseFirestore.instance
        .collection(currentCollection)
        .doc(email)
        .set({
      "name": name,
      "email": email,
      "role": role,
      "contact": contact,
      "geo": latLng
    });
  }

  registerUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Fluttertoast.showToast(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Fluttertoast.showToast(
            msg: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

  login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
  }

  isProfileUpdated(email) async {
    bool exists;
    getCurrentCollection();
    await Future.delayed(Duration(seconds: 2));
    await FirebaseFirestore.instance
        .collection(currentCollection)
        .doc(email)
        .get()
        .then((doc) => {
              if (doc.exists) {exists = true} else {exists = false}
            });
    return exists;
  }

  getRoleList() {
    return FirebaseFirestore.instance.collection(otherCollection).snapshots();
  }

  Future<String> getRoleToDisplay(String email) async {
    String roleToDisplay;
    await FirebaseFirestore.instance
        .collection("social_service_org")
        .doc(email)
        .get()
        .then((doc) => {
              if (doc.exists)
                {roleToDisplay = "restaurant"}
              else
                {roleToDisplay = "social_service_org"}
            });
    return roleToDisplay;
  }

  Future<void> getCurrentCollection() async {
    String roleToDisplay;
    email = FirebaseAuth.instance.currentUser.email;
    await FirebaseFirestore.instance
        .collection("social_service_org")
        .doc(email)
        .get()
        .then((doc) => {
              if (doc.exists)
                {
                  currentCollection = "social_service_org",
                  otherCollection = "restaurant"
                }
              else
                {
                  currentCollection = "restaurant",
                  otherCollection = "social_service_org"
                }
            });
  }
}
