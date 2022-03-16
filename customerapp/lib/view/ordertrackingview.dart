import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class TrackOrderView extends StatefulWidget {
  const TrackOrderView({Key? key}) : super(key: key);

  @override
  _TrackOrderViewState createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final CameraPosition initLocation = const CameraPosition(
    target: LatLng(6.820934, 80.041671),
    zoom: 10,
  );

  void _onMapCreated(GoogleMapController controller) {

    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(9.669111, 80.014007),
      // icon: BitmapDescriptor.,
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
        title: Text('Track Your Order'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/3,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Order No"),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Timestamp"),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Items"),
                            )
                        ),
                        Expanded(
                          flex: 6,
                          child: ListView(
                            children: [
                              Text('Large Pizza x 3'),
                              Text('Large Pizza x 3'),
                              Text('Large Pizza x 3'),
                              Text('Large Pizza x 3'),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text("Total Price: Rs. 5000"),
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text("Delivery Location"),
              ),
              Container(
                height: MediaQuery.of(context).size.height/2,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}
