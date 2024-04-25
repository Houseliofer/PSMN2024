import 'dart:async';

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const LatLng sourceLocation =
      LatLng(20.514653760948, -100.81471397440137);
  static const LatLng destination = LatLng(20.5410006, -100.8158513);

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polypoints = PolylinePoints();

    PolylineResult result = await polypoints.getRouteBetweenCoordinates(
        'AIzaSyAHlJYgFnbnOFc_dahstIg21K8N1Sy4EFI',
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(
            point.latitude,
            point.longitude,
          ),
        ),
      );
      setState(() {});
    }
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: sourceLocation,
    zoom: 20,
  );

  static const CameraPosition _kLake = CameraPosition(
      //bearing: 192.8334901395799,
      target: destination,
      //tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CircularMenu(
      backgroundWidget: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          const Marker(markerId: MarkerId('source'), position: sourceLocation),
          const Marker(markerId: MarkerId('destination'), position: destination)
        },
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.purple,
          ),
        },
      ),
      items: [
        CircularMenuItem(
          icon: Icons.home,
          onTap: () {},
          color: Colors.green,
          iconColor: Colors.white,
        ),
        CircularMenuItem(
          icon: Icons.search,
          onTap: () {},
          color: Colors.orange,
          iconColor: Colors.white,
        ),
        CircularMenuItem(
          icon: Icons.settings,
          onTap: () {},
          color: Colors.deepPurple,
          iconColor: Colors.white,
        ),
        CircularMenuItem(
          icon: Icons.settings,
          onTap: () {},
          color: Colors.deepPurple,
          iconColor: Colors.white,
        )
      ],
    )

        /*GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),*/
        );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
