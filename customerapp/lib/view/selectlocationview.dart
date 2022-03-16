import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationView extends StatefulWidget {
  const SelectLocationView({Key? key}) : super(key: key);

  @override
  State<SelectLocationView> createState() => _SelectLocationViewState();
}

class _SelectLocationViewState extends State<SelectLocationView> {

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late LatLng lastTap;

  final CameraPosition initLocation = const CameraPosition(
    target: LatLng(6.820934, 80.041671),
    zoom: 10,
  );

  void _onMapCreated(GoogleMapController controller) {

    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(9.669111, 80.014007),
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: initLocation,
          onMapCreated: _onMapCreated,
          compassEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          markers: markers.values.toSet(),
          onTap: (LatLng pos) {
            setState(() {
              lastTap = pos;
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context, lastTap);
        },
        child: Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
