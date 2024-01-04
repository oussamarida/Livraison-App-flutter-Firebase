import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class OrderItem {
  final String name;
  final String image;
  final double price;
  int quantity; 

  OrderItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'image': image,
        'quantity': quantity,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        name: json['name'],
        image: json["image"],
        price: json['price'],
        quantity: json['quantity'] ?? 1,
      );
}

Future<List<OrderItem>> loadOrdersFromSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final ordersString = prefs.getStringList('orders') ?? [];
  final List<OrderItem> loadedOrders = [];

  for (final orderString in ordersString) {
    if (orderString != null) {
      try {
        final order = OrderItem.fromJson(jsonDecode(orderString));
        loadedOrders.add(order);
      } catch (e) {
        print('Error decoding order: $e');
      }
    }
  }

  return loadedOrders;
}



class Panie extends StatefulWidget {
  @override
  _PanieState createState() => _PanieState();
}

class _PanieState extends State<Panie> {
  List<OrderItem> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final loadedOrders = await loadOrdersFromSharedPreferences();
    setState(() {
      orders = loadedOrders;
    });
  }



  void Total(int index) {
    setState(() {
      orders.removeAt(index);
    });
  }


void removeAllOrders() async {
  setState(() {
    orders.clear();
  });
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.remove("orders"); 
}

void removeOrder(int index) async {
  setState(() {
    orders.removeAt(index);
  });
  await saveOrdersToSharedPreferences(orders);
}

Future<void> saveOrdersToSharedPreferences(List<OrderItem> orders) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> ordersStringList =
      orders.map((order) => jsonEncode(order.toJson())).toList();
  await prefs.setStringList('orders', ordersStringList);
}

double calculateTotal() {
  double total = 0.0;
  for (var order in orders) {
    total += order.price * order.quantity;
  }
  return total;
}


Future<void> submitAllQuantities() async {
  // Get the current user
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    CollectionReference ordersCollection =FirebaseFirestore.instance.collection('orders');
    List<Map<String, dynamic>> ordersData = orders.map((order) {
      return {
        'name': order.name,
        'price': order.price,
        'quantity': order.quantity,
        "image": order.image
      };
    }).toList();

    Map<String, dynamic> userData = {
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
    };

    if (ordersData.isNotEmpty) {
      await ordersCollection.add({
        'user': userData,
        'orders': ordersData,
        'timestamp': FieldValue.serverTimestamp(),
      });

      removeAllOrders();
    
    } else {
    
    }
  } else {
    // Handle the case where the user is not signed in
    print('User not signed in');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color (white)
      appBar: AppBar(
        title: Text('Panie'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(order.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Information on the right
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(children: [
                                      Text(
                                order.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width:20),
                              Text(
                                '\$${order.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                                  ],),
                                   Positioned(
                                    top: 10,
                                    right: 10,
                                    child: IconButton(
                                      onPressed: () {
                                        removeOrder(index);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Quantity:",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            order.quantity++;
                                          });
                                              saveOrdersToSharedPreferences(orders);
                                        },
                                        child: Text('+'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: Colors.black,
                                          side: BorderSide(
                                            color: Colors.black,
                                          ),
                                          minimumSize:
                                              Size(20, 15),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        ' ${order.quantity}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (order.quantity > 1) {
                                            setState(() {
                                              order.quantity--;
                                              saveOrdersToSharedPreferences(orders);
                                            });
                                          }
                                        },
                                        child: Text('-'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: Colors.black,
                                          side: BorderSide(
                                            color: Colors.black,
                                          ),
                                          minimumSize:
                                              Size(20, 15),
                                        ),
                                      ),
                                    ],
                                  ),
                            
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          Column(
            
            children: [
              Text(
  "Total: \$${calculateTotal().toStringAsFixed(2)}",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  removeAllOrders();
                },
                child: Text('Cancel All Orders'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Red button
                  onPrimary: Colors.white, // White text
                ),
              ),
                SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  submitAllQuantities();
                },
                child: Text('Confirme your orders'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[700], // Button color (green)
                  onPrimary: Colors.white, // White text
                ),
              ),
             
            ],
          ),
        ],
      ),
    );
  }
}
