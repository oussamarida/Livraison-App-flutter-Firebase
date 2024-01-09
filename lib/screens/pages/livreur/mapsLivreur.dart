import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';


class MapScreenLivreur extends StatefulWidget {
  @override
  _MapScreenLivreurState createState() => _MapScreenLivreurState();
}

class _MapScreenLivreurState extends State<MapScreenLivreur> {
  List<Map<String, dynamic>> orders = [];
  LatLng? currentLocation;
  MapController mapController = MapController();
  Timer? locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    fetchOrders();
    fetchCurrentLocation();

    // Start a timer to update the location periodically
    locationUpdateTimer = Timer.periodic(Duration(seconds: 30), (Timer timer) {
      fetchCurrentLocation();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    locationUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchOrders() async {
    CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('orders');
    QuerySnapshot ordersSnapshot =
        await ordersCollection.where('type', isEqualTo: 'pending').get();

    setState(() {
      orders = ordersSnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> fetchCurrentLocation() async {
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

  double? _calculateTotal(List<dynamic>? orderItems) {
    if (orderItems == null || orderItems.isEmpty) {
      return null;
    }

    return orderItems.fold<double?>(0.0, (previousValue, item) {
      final price = item['price'] as num? ?? 0.0;
      final quantity = item['quantity'] as num? ?? 1;
      return previousValue! + price * quantity;
    });
  }

  Future<void> _showOrderDetailsDialog(
      BuildContext context, Map<String, dynamic> order) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Details'),
          content: SingleChildScrollView(
            child: Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User: ${order['user']['email'] ?? ''}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        for (var item in order['orders'])
                          Row(
                            children: [
                              if (item['image'] != null)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Item: ${item['name']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Quantity: ${item['quantity']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Price: \$${item['price']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              SizedBox(width: 16),
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(item['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                            ],
                          ),
                        SizedBox(height: 12),
                        Text(
                          'Total: \$${_calculateTotal(order['orders'])?.toStringAsFixed(2) ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Timestamp: ${order['timestamp'].toDate()}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                _handleOrderClose(context, order);
              },
              child: Text('Take Order'),
            ),
          ],
        );
      },
    );
  }

  void _handleOrderClose(BuildContext context, Map<String, dynamic> order) async {
    CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orders');
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      User? user = auth.currentUser;

      if (user != null) {
        Position? position = await _getCurrentLocation();

        if (position != null) {
          Query query = ordersCollection
              .where('timestamp', isEqualTo: order['timestamp'])
              .where('user.email', isEqualTo: order['user']['email']);

          query.get().then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              DocumentSnapshot document = querySnapshot.docs.first;
              document.reference.update({
                'type': 'coming',
                'deliveryUser': {
                  'email': user.email,
                'deliveryLocation': '${position.latitude}, ${position.longitude}',
                  
                },
              }).then((value) {
                print('Order updated successfully in Firebase');
                fetchOrders();
                Navigator.of(context).pop();
              }).catchError((error) {
                print('Error updating order in Firebase: $error');
              });
            } else {
              print('No matching document found');
            }
          }).catchError((error) {
            print('Error querying orders in Firebase: $error');
          });
        } else {
          print('Location information not available');
        }
      } else {
        print('User not authenticated');
      }
    } catch (error) {
      print('Error getting current user: $error');
    }
  }

  Future<Position?> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition().catchError((error) {
      print('Error getting current location: $error');
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter:
              currentLocation ?? LatLng(31.662821399290678, -8.022558632311567),
          initialZoom: currentLocation != null
              ? 12.0
              : 5.0,
        ),
        mapController: mapController,
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          if (currentLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: currentLocation!,
                  width: 40,
                  height: 40,
                  child: Image.asset(
                    'assets/mylocation.png',
                    width: 10,
                    height: 10,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          MarkerLayer(
            markers: orders
                .map(
                  (order) => Marker(
                    point: _getLatLngFromLocationString(order['location']),
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: AssetImage('assets/placeholder.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => _showOrderDetailsDialog(context, order),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          padding: EdgeInsets.zero,
                          elevation: 0,
                        ),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  LatLng _getLatLngFromLocationString(String location) {
    List<String> coordinates = location.split(',');
    double latitude = double.parse(coordinates[0]);
    double longitude = double.parse(coordinates[1]);
    return LatLng(latitude, longitude);
  }
}
