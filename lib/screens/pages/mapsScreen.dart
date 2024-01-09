import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final Map<String, dynamic> orderInfo;

  MapScreen({required this.orderInfo});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentLocation;
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLocation = LatLng(
          position.latitude,
          position.longitude,
        );
      });

      if (currentLocation != null) {
        mapController.move(currentLocation!, 12.0);
      }
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    LatLng orderLocation = _getLatLngFromLocationString(widget.orderInfo['deliveryUser']['deliveryLocation']);
    LatLng myLocation = currentLocation != null
        ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
        : LatLng(0, 0); // Default to (0, 0) if current location is not available
    print('Order Information: ${orderLocation}'); // Print the orderInfo

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: orderLocation ?? LatLng(31.662821399290678, -8.022558632311567),
          initialZoom: orderLocation != null ? 12.0 : 5.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: orderLocation,
                width: 80,
                height: 80,
                child: Image.asset(
                  'assets/mylocation.png',
                  width: 10,
                  height: 10,
                  fit: BoxFit.cover,
                ),
              ),
              Marker(
                point: myLocation,
                width: 80,
                height: 80,
                child: Image.asset(
                  'assets/placeholder.png',
                  width: 10,
                  height: 10,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // This will pop the current screen and go back.
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }

  LatLng _getLatLngFromLocationString(String location) {
    List<String> coordinates = location.split(',');
    double latitude = double.parse(coordinates[0]);
    double longitude = double.parse(coordinates[1]);
    return LatLng(latitude, longitude);
  }

  void launchUrl(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }
}
