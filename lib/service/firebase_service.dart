import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madad/domain/user.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FirebaseService extends ChangeNotifier {
  String email;
  String collection;
  String currentCollection;
  String otherCollection;
  static FirebaseService firebaseService;
  int notificationCounter = 0;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.;
  String _message = '';
  static getFirebaseService() {
    if (firebaseService == null) {
      firebaseService = FirebaseService();
    }
    return firebaseService;
  }

  Future addOrganisation(BuildContext context, String name, String role,
      String contact, String address, GeoPoint latLng, String topic) async {
    if (role == "Restaurant") {
      currentCollection = "restaurant";
      otherCollection = "social_service_org";
    } else {
      currentCollection = "social_service_org";
      otherCollection = "restaurant";
    }
    email = FirebaseAuth.instance.currentUser.email;
    await FirebaseFirestore.instance
        .collection(currentCollection)
        .doc(email)
        .set({
      "name": name,
      "email": email,
      "role": role,
      "contact": contact,
      "address": address,
      "geo": latLng,
      "topic": topic
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
        await setCurrentCollection();
        registerOnFirebase();
        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  logout() async {
    MyUser user;
    await getUserData().then((value) => user = value);
    print("topic ${user.topic}");
    print("unsubscribing from ${user.role}");
    notificationCounter = 0;
    FirebaseMessaging.instance.unsubscribeFromTopic(user.role);
    await FirebaseAuth.instance.signOut();
  }

  isProfileUpdated(email) async {
    bool exists;
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

  getProfile() {
    return FirebaseFirestore.instance
        .collection(currentCollection)
        .doc(email)
        .snapshots();
  }

  Future<void> setCurrentCollection() async {
    print("2222222222222222222222222222222setCurrentCollection");
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

  Future<void> addNotification(RemoteMessage message) async {
    print("===============================inside add notification1");
    email = FirebaseAuth.instance.currentUser.email;
    print("===============================inside add notification2");
    bool exists = false;
    // DocumentReference docRef =
    await FirebaseFirestore.instance
        .collection("notification")
        .doc(email)
        .get()
        .then((doc) => {
              if (doc.exists) {exists = true} else {exists = false}
            });
    // print("===============================inside add notification3");
    // docRef.get().then((doc) => {
    //       print("00000000000000000000000000000"),
    // if (doc.exists) {exists = true} else {exists = false}
    //     });

    print("444444444444444444444444444444444444444444444 $exists");
    if (exists) {
      FirebaseFirestore.instance.collection("notification").doc(email).update({
        "notification": FieldValue.arrayUnion([
          {
            "id": Random().nextInt(10000),
            "age": "${message.data["ageGroup"]}",
            "sender": "${message.data["sender"]}",
            "total-req": "${message.data["peopleCount"]}",
            "type": "${message.data["type"]}",
          }
        ])
      });
    } else {
      FirebaseFirestore.instance.collection("notification").doc(email).set({
        "notification": FieldValue.arrayUnion([
          {
            "id": Random().nextInt(10000),
            "age": "${message.data["ageGroup"]}",
            "sender": "${message.data["sender"]}",
            "total-req": "${message.data["peopleCount"]}",
            "type": "${message.data["type"]}",
          }
        ])
      });
    }
  }

  getNotification() {
    email = FirebaseAuth.instance.currentUser.email;
    return FirebaseFirestore.instance
        .collection("notification")
        .doc(email)
        .snapshots();
  }

  void resetCounter() {
    notificationCounter = 0;
    notifyListeners();
  }

  registerOnFirebase() async {
    print(
        "333333333333333333333333333333333333333333333333333333 regidteronFirebase");
    MyUser user;
    await getUserData().then((value) => user = value);
    print("topic ${user.topic}");
    print("subscribr to ${user.role}");
    FirebaseMessaging.instance.subscribeToTopic(user.role);
    FirebaseMessaging.instance.getToken().then((token) => print(token));
  }

  void incrementCounter() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(" =--------------------========----------");
      if (message != null) {
        print(message.notification.title);
        print(message.notification.body);
        addNotification(message);
        notificationCounter++;
        notifyListeners();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      if (message != null) {
        print(message.notification.title);
        print(message.notification.body);
        addNotification(message);
        notificationCounter++;
        notifyListeners();
      }
    });
  }

  int getCounter() {
    return notificationCounter;
  }

  getUserData() async {
    MyUser user = MyUser();
    email = FirebaseAuth.instance.currentUser.email;
    print(
        "11111111111111111111111111111111111111111 getUserData $currentCollection");
    var lol = await FirebaseFirestore.instance
        .collection(currentCollection)
        .doc(email)
        .get()
        .then((value) => {
              user.name = value.get("name"),
              user.email = value.get("email"),
              user.contact = value.get("contact"),
              user.role = value.get("role"),
              user.topic = value.get("topic"),
              user.address = value.get("address"),
              user.geoPoint = value.get("geo")
            });
    return user;
  }

  sendNotification(String type, String peopleCount, String ageGroup) async {
    MyUser user;
    await getUserData().then((value) => user = value);
    email = FirebaseAuth.instance.currentUser.email;
    Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    var body = jsonEncode({
      "notification": {"body": "baba", "title": "black sheep4"},
      "priority": "high",
      "data": {
        "clickaction": "FLUTTERNOTIFICATIONCLICK",
        "id": "1",
        "status": "done",
        "sender": "$email",
        "type": "$type",
        "peopleCount": "$peopleCount",
        "ageGroup": "$ageGroup"
      },
      "to": "/topics/${user.topic}"
    });

    var header = {
      "content-type": "application/json",
      "Authorization":
          "key=AAAAY0o7iGE:APA91bHfbYr7nZiXuBJVUh5rBnVU5p14X4YAWr8ugutok8scXeEv-raxrdQYEPz9kamHJs2uutQUcLPLnl9WKOAHTKSn7RcNau6hJjGo3dPvs36J6t4sAsLfCiZulLLPOU3CLl6drYNx"
    };
    var response = http.post(url, body: body, headers: header);
    print(response.then((value) => {
          if (value.statusCode == 200)
            {Fluttertoast.showToast(msg: "Request Sent")}
          else
            {Fluttertoast.showToast(msg: "Something went wrong")}
        }));
  }
}
