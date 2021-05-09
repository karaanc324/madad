import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import "package:latlong/latlong.dart" as latLng;

class Helper {
  Position currentPosition;
  var geoLocator = Geolocator();
  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    currentPosition = position;
    print("============================");
    print(position);
    // LatLng latLanPosition = LatLng(position.latitude, position.longitude);
    return position;
  }
}
