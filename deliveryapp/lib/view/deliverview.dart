import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliverView extends StatefulWidget {

  String orderID;
  String customerName;
  String phoneNo;
  GeoPoint customerLocation;

  DeliverView(this.orderID,this.customerName,this.phoneNo,this.customerLocation, {Key? key}) : super(key: key);

  @override
  _DeliverViewState createState() => _DeliverViewState();
}

class _DeliverViewState extends State<DeliverView> {

  late BitmapDescriptor markerIcon;
  late GoogleMapController mapController;
  static final _initialPosition = LatLng(7.2906, 80.6337);
  LatLng _lastPostion = _initialPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    setMapMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.orderID),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(widget.customerName),
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.phoneNo),
                  ),
                  OutlinedButton(onPressed: () {}, child: Text('Call'),),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Delivery Location'),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                color: Colors.teal,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.customerLocation.latitude, widget.customerLocation.longitude),
                    zoom: 15.0,
                  ),
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  compassEnabled: true,
                  onCameraMove: _onCameraMove,
                  markers: _markers,

                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _settingModalBottomSheet(context);
                    },
                    child: Text('View Order')),
                  OutlinedButton(
                    onPressed: () {}, child: Text('Mark As Delivered')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    showCustomerLocation();
  }

  void showCustomerLocation() async {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('customer'),
          position: LatLng(widget.customerLocation.latitude, widget.customerLocation.longitude),
          icon: markerIcon,
        ),
      );
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(widget.customerLocation.latitude, widget.customerLocation.longitude),
        ),
      );
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPostion = position.target;
    });
  }

  void setMapMarker() async{
    markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(25,25   )), 'assets/cIcon.png');
  }

}

void _settingModalBottomSheet(context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        height: 270,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Text('Total Price: Rs.5000'),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  child: ListView(
                    children: [
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      );
    }
  );
}
