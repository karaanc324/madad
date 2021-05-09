import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class MyMaps extends StatefulWidget {
  @override
  _MyMapsState createState() => _MyMapsState();
}

class _MyMapsState extends State<MyMaps> {
  Position position;
  LatLng latLng1;
  @override
  void initState() {
    super.initState();
    setState(() {
      callPosition();
    });
    Future.delayed(Duration(milliseconds: 3000));
  }

  callPosition() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) => position = value);
    print("===============-----------------");
    print(position);
    setState(() {
      latLng1 = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 3000));
    if (position != null) {
      return Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              onTap: (latLng) {
                setState(() {
                  latLng1 = latLng;
                });
              },
              center: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
              maxZoom: 18,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 30.0,
                    height: 30.0,
                    anchorPos: AnchorPos.align(AnchorAlign.center),
                    point: latLng1,
                    builder: (ctx) => Container(
                      child: Icon(Icons.location_on),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            // add your floating action button
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context, latLng1);
                // return latLng1;
              },
              child: Text('Save'),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
