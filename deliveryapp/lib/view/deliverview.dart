import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/model/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliverView extends StatefulWidget {

  String orderID;
  String customerName;
  String phoneNo;
  GeoPoint customerLocation;
  String price;

  DeliverView(this.orderID,this.customerName,this.phoneNo,this.customerLocation,this.price, {Key? key}) : super(key: key);

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
                  OutlinedButton(
                    onPressed: () {
                      launch("tel://214324234");
                    },
                    child: Text('Call'),
                  ),
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
                    zoom: 10.0,
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
                      _settingModalBottomSheet(context,widget.price,widget.orderID);
                    },
                    child: Text('View Order')),
                  OutlinedButton(
                    onPressed: () {
                      Order().markAsDelivered(widget.orderID);
                    },
                    child: Text('Mark As Delivered'),
                  ),
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
    markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(25,25)), 'assets/cIcon.png');
  }

}

void _settingModalBottomSheet(context,String price,String orderID) {
  final Stream<QuerySnapshot> items = FirebaseFirestore.instance.collection('orders').doc(orderID).collection('items').snapshots();
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total Price: Rs.$price',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Expanded(
                flex: 8,
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: items,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text('${data['name']}  x${data['quantity']}  =  ${data['price']}'),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  );
}
