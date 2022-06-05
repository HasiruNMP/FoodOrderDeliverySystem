import 'dart:async';
import 'package:customerapp/view/showlocation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:intl/intl.dart';

import '../api/apiservice.dart';
import '../controller/orderitemsmodel.dart';
import '../controller/productmodel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class StreamSocket{
  final _socketResponse= StreamController<String?>();

  void Function(String?) get addResponse => _socketResponse.sink.add;

  Stream<String?> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }
}

StreamSocket streamSocket =StreamSocket();

class TrackOrderView extends StatefulWidget {
  String orderId;
  String dateTime;
  double totalPrice;

  TrackOrderView(this.orderId, this.dateTime, this.totalPrice);

  @override
  _TrackOrderViewState createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> markers = {};
  String d = '12312';

  final CameraPosition initLocation = const CameraPosition(
    target: LatLng(6.820934, 80.041671),
    zoom: 10,
  );

  void _onMapCreated(GoogleMapController controller) {
    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(6.820934, 80.041671),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );

    setState(() {
      markers.add(marker);
    });
  }

  late Future<List<productModel>> productDetails;
  late Future<List<orderItemModel>> orderItems;

  void connectAndListen(){
    IO.Socket socket = IO.io('https://fods-geotrack.herokuapp.com',
        OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('connect');
      socket.emit('message', 'connected');
    });

    //When an event recieved from server, data is added to the stream
    socket.on('LocationUpdated', (data) {
      setState(() {
        print(data);
        print(data);
        d = data;
        /*markers.add(Marker(
          markerId: MarkerId('place_name'),
          position: LatLng(data['latitude'], data['longitude']),
        ));*/
      });
    });
    socket.onDisconnect((_) => print('disconnect'));

  }

  @override
  void initState() {
    super.initState();
    orderItems = APIService.getOrderItems(int.parse(widget.orderId));
    //connectAndListen();
  }

  late String status;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Track Your Order'),
        ),
        body: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Container(
                    //height: MediaQuery.of(context).size.height / 3,
                    child: Card(
                      color: Colors.blueGrey.shade50,
                      child: Column(
                        children: [
                          SizedBox(height: 5,),
                          Container(
                            alignment: Alignment.center,
                            child: Text("Order No: ${widget.orderId}",style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            alignment: Alignment.center,
                            child: Text(widget.dateTime),
                          ),
                          Divider(
                            color: Colors.black38,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5,left: 10),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Items",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 5,
                            child: FutureBuilder<List<orderItemModel>>(
                                future: orderItems,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text("Something went wrong");
                                  }

                                  // if (snapshot.connectionState ==
                                  //         ConnectionState.waiting ||
                                  //     !snapshot.hasData) {
                                  //   return CircularProgressIndicator();
                                  // }

                                  if (snapshot.hasData) {
                                    print('has data in Order Items');
                                    List<orderItemModel>? data = snapshot.data;

                                    return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: data!.length,
                                        itemBuilder: (BuildContext context, i) {
                                          productDetails =
                                              APIService.getProductDetails(
                                                  data[i].productId);

                                          return FutureBuilder<
                                                  List<productModel>>(
                                              future: productDetails,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      "Something went wrong");
                                                }

                                                // if (snapshot.connectionState ==
                                                //         ConnectionState.waiting ||
                                                //     !snapshot.hasData) {
                                                //   return CircularProgressIndicator();
                                                // }

                                                if (snapshot.hasData) {
                                                  print(
                                                      'has data in Order Items');
                                                  List<productModel>? product =
                                                      snapshot.data;

                                                  return Container(
                                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                    child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            product!.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                index) {
                                                          return Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                    '${product[index].name}  '),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  ' ${data[i].quantity} x ${product[index].price}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  alignment: Alignment.centerRight,
                                                                  child: Text(
                                                                      ' = ${product[index].price * data[i].quantity}'),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                  );
                                                }
                                                return Container(
                                                  height: 100,
                                                  width: 100,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              });
                                        });
                                  }
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }),
                          ),
                          Divider(
                            color: Colors.black38,
                          ),
                          Container(
                            //margin: EdgeInsets.only(top: 5, right: 58),
                            alignment: Alignment.center,
                            child:
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text("Total Price: Rs. ${widget.totalPrice}",style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                          ),
                          SizedBox(height: 8,),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShowLiveLocation()),
                        );
                      },
                      child: Text("Track Delivery"),
                    ),
                  ),
                  /*Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: initLocation,
                      onMapCreated: _onMapCreated,
                      compassEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      markers: markers
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ));
  }
}
