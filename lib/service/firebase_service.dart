import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong/latlong.dart';

class FirebaseService {
  String email;
  String collection;
  String currentCollection;
  String otherCollection;
  FirebaseService() {
    Firebase.initializeApp();
    getCurrentCollection();
  }

  Future addOrganisation(BuildContext context, String name, String role,
      String contact, GeoPoint latLng) async {
    email = FirebaseAuth.instance.currentUser.email;
    if (role == "Restaurant") {
      collection = "restaurant";
    } else {
      collection = "social_service_org";
    }
    print("---------------------------");
    print(email);
    await FirebaseFirestore.instance.collection(collection).doc(email).set({
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
      print("------------------------------");
      return true;
      // print(userCredential.user.email);
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
      print("------------------------------");
      if (userCredential != null) {
        return true;
      }
      // print(userCredential.user.email);
    } catch (e) {
      print(e);
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
  }

  isProfileUpdated(email) async {
    bool exists;
    // todo
    // if (FirebaseFirestore.instance.collection("user_data").doc(email).get() != null) {
    //   return true;
    // } else {
    //   return false;
    // }
    // getCurrentCollection();
    print("111111111111");
    await Future.delayed(Duration(seconds: 2));
    print("333333333333333333333333333333$currentCollection");
    await FirebaseFirestore.instance
        .collection(currentCollection)
        .doc(email)
        .get()
        .then((doc) => {
              if (doc.exists)
                {print("2222222222222"), exists = true}
              else
                {print("3333333333333"), exists = false}
            });
    return exists;
  }

  getRoleList(String collection) {
    return FirebaseFirestore.instance.collection(collection).snapshots();
  }

  getProfile(String email) {
    return FirebaseFirestore.instance
        .collection("social_service_org")
        .snapshots();
  }

  Future<String> getRoleToDisplay(String email) async {
    // FirebaseFirestore.instance.collection("social_service_org")
    String roleToDisplay;
    await FirebaseFirestore.instance
        .collection("social_service_org")
        .doc(email)
        .get()
        .then((doc) => {
              if (doc.exists)
                {print("2222222222222"), roleToDisplay = "restaurant"}
              else
                {print("3333333333333"), roleToDisplay = "social_service_org"}
            });
    return roleToDisplay;
  }

  getRoles(String roleToGet) {
    return FirebaseFirestore.instance.collection(roleToGet).snapshots();
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
                  print("2222222222222"),
                  currentCollection = "social_service_org",
                  otherCollection = "restaurant"
                }
              else
                {
                  print("3333333333333"),
                  currentCollection = "restaurant",
                  otherCollection = "social_service_org"
                }
            });
    // currentCollection = roleToDisplay;
    // otherCollection =
  }
}
