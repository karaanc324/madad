import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

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
    setCurrentCollection();
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
    print("=============" + otherCollection);
    return FirebaseFirestore.instance.collection(otherCollection).snapshots();
  }

  getProfile() {
    return FirebaseFirestore.instance
        .collection(currentCollection)
        .doc(email)
        .snapshots();
  }

  Future<void> setCurrentCollection() async {
    print("###########################################");
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

  void resetCounter() {
    notificationCounter = 0;
    notifyListeners();
  }

  registerOnFirebase() {
    FirebaseMessaging.instance.subscribeToTopic('all');
    FirebaseMessaging.instance.getToken().then((token) => print(token));
  }

  void incrementCounter() {
    print("========================== increment counter called");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message != null) {
        // print(message);
        print('received message');
        notificationCounter++;
        notifyListeners();
      }
      print(notificationCounter);
    });

    // incrementCounter() {
    //   Provider.of(_, listen: false).inc
    //   notifyListeners();
    //   notificationCounter++;
    // }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      if (message != null) {
        print(message);
        print('received messagelolol');
        // notificationCounter++;
        // notifyListeners();
      }
      print(this.notificationCounter);
      // Provider.of<FirebaseService>().incrementCounter();
      // notifyListeners();
      // Navigator.push(BuildContext(), route)
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });
  }

  int getCounter() {
    return notificationCounter;
  }

  //       onMessage: (Map<String, dynamic> message) async {
  //     print('received message');
  //     setState(() => _message = message["notification"]["body"]);
  //   }, onResume: (Map<String, dynamic> message) async {
  //     print('on resume $message');
  //     setState(() => _message = message["notification"]["body"]);
  //   }, onLaunch: (Map<String, dynamic> message) async {
  //     print('on launch $message');
  //     setState(() => _message = message["notification"]["body"]);
  //   });
  // }
}
