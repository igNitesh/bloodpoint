import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';



class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  List<Marker> markers = [];
  late GoogleMapController controller;
  late LatLng currentLocation = LatLng(0, 0);

  onMapCreated(GoogleMapController controller) async {
    // GoogleMapsFlutterPlatform.instance.setApiKey("AIzaSyCL4hJ9mIYDSCN6a6zdX16kCI7Lln3q9zY");
    this.controller = controller;
    var locationData = await Location().getLocation();
    Position? position = await Geolocator.getCurrentPosition();
    // if (position != null) {
  currentLocation = LatLng(position.latitude, position.longitude);
    // }

    print(locationData.longitude);
    print(locationData.latitude);
    setState(() {
      markers.add(
        Marker(
            markerId: MarkerId("Mylocation"),
            position: currentLocation,
            draggable: true,
            onTap: () {
              print("tapped");
            },
            consumeTapEvents: true,
            infoWindow: InfoWindow(title: "Your location")),
      );
    });

    controller.animateCamera(CameraUpdate.newLatLngZoom(currentLocation, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick your Location'),
      ),
      body: GoogleMap(
          onMapCreated: (controller) => onMapCreated(controller),
          initialCameraPosition: CameraPosition(
            target: LatLng(0, 0),
            zoom: 6,
          ),
          
          markers: Set<Marker>.of(markers)),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Pick'),
        icon: Icon(Icons.location_on),
        onPressed: () {
          Navigator.pop(context, currentLocation);
        },
      ),
    );
  }
}
