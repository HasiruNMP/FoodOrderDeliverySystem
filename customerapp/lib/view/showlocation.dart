import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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



class ShowLiveLocation extends StatefulWidget {

  @override
  State<ShowLiveLocation> createState() => _ShowLiveLocationState();
}

class _ShowLiveLocationState extends State<ShowLiveLocation> {

  String str = "no data yet";
  late BitmapDescriptor busicon;

  @override
  void initState() {
    //connectAndListen();
    setMapMarker();
  }
  void connectAndListen(){
    IO.Socket socket = IO.io('https://fods-geotrack.herokuapp.com',
        OptionBuilder()
            .setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('connect');
      socket.emit('message', 'connected');
    });

    //When an event recieved from server, data is added to the stream
    socket.on('message', (data) {
      print("qweqwe");
      setState(() {
        print(data);
        str = data['longitude'].toString();
        _markers.add(
            Marker(
              markerId: MarkerId('bus'),
              position: LatLng(data['latitude'], data['longitude']),
              icon: busicon,
            ));

        mapController.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(data['latitude'], data['longitude']),
          ),
        );
      });
    });
    socket.onDisconnect((_) => print('disconnect'));

  }


  late GoogleMapController mapController;
  static const _initialPosition = LatLng(7.2906, 80.6337);
  LatLng _lastPostion = _initialPosition;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    connectAndListen();
    setState(() {
      mapController = controller;
      _markers.add(
          Marker(
            markerId: MarkerId('bus'),
            position: LatLng(6.8213291,80.0415729),
            icon: busicon,
          ));
    });
  }

  void setMapMarker() async{
    busicon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(60,60)), 'assets/bus.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Live Location"),
      ),
      body: SafeArea(
        child: Container(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: LatLng(6.8213291,80.0415729), zoom: 15.0,),
            myLocationEnabled: true,
            mapType: MapType.normal,
            compassEnabled: true,
            //onCameraMove: _onCameraMove,
            markers: _markers,

          ),
        ),
      )
    );
  }
}
