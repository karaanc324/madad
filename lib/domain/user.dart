import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String _name;

  String get name => _name;

  set name(String name) {
    _name = name;
  }

  String _email;

  String get email => _email;

  set email(String email) {
    _email = email;
  }

  String _contact;

  String get contact => _contact;

  set contact(String contact) {
    _contact = contact;
  }

  String _role;

  String get role => _role;

  set role(String role) {
    _role = role;
  }

  String _topic;

  String get topic => _topic;

  set topic(String topic) {
    _topic = topic;
  }

  String _address;

  String get address => _address;

  set address(String address) {
    _address = address;
  }

  GeoPoint _geoPoint;

  GeoPoint get geoPoint => _geoPoint;

  set geoPoint(GeoPoint geoPoint) {
    _geoPoint = geoPoint;
  }
}
