import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last_livrai/screens/login.dart';
import 'package:last_livrai/screens/signin.dart';

class MenuLivreur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            return _buildOrdersList(user.email!); // Pass the email to fetch orders
          } else {
            return LoginPage();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildOrdersList(String deliveryPersonEmail) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('deliveryUser.email', isEqualTo: deliveryPersonEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<Map<String, dynamic>> orders = snapshot.data!.docs
            .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
            .toList();

        if (orders.isEmpty) {
          return Center(child: Text('No orders available for delivery.'));
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            // Build your order item widget here using orders[index]
            return Card(
              color: Colors.black, // Set the background color to black
              elevation: 3,
              margin: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'User Email: ${orders[index]['user']['email']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total: \$${_calculateTotal(orders[index]['orders'])?.toStringAsFixed(2) ?? 'N/A'}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Timestamp: ${orders[index]['timestamp'].toDate()}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.white), // Set button color to white
                            onPressed: () {
                              _showOrderDetailsDialog(context, orders[index]);
                            },
                            child: Text('More Details', style: TextStyle(color: Colors.black)), // Set text color to black
                          ),
                          SizedBox(width: 8),
                          if (orders[index]['type'] == 'coming')
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white, // Set button color to white
                                minimumSize: Size(120, 40), // Set button size
                              ),
                              onPressed: () {
                                _handleOrderDone(context, orders[index]);
                              },
                              child: Text('Done', style: TextStyle(color: Colors.black)), // Set text color to black
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
void _showOrderDetailsDialog(BuildContext context, Map<String, dynamic> order) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
    backgroundColor: Colors.black, // Set the background color of the AlertDialog to black
        title: Text('More Details',style: TextStyle(color: Colors.white)),
        content: Card(
          color: Colors.black, // Set the background color of the Card to black
          elevation: 3,
          margin: EdgeInsets.all(2),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding to the Card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User: ${order['user']['email'] ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set text color to white
                  ),
                ),
                for (var item in order['orders'])
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (item['image'] != null)
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
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Item: ${item['name']}',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                Text(
                                  'Quantity: ${item['quantity']}',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                Text(
                                  'Price: \$${item['price']}',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
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
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Timestamp: ${order['timestamp'].toDate()}',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close', style: TextStyle(color: Colors.white)), // Set text color to white
          ),
        ],
      );
    },
  );
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

  void _handleOrderDone(BuildContext context, Map<String, dynamic> order) async {
  try {
    // Update the type field to 'success' in Firestore
    await FirebaseFirestore.instance
        .collection('orders')
        .where('timestamp', isEqualTo: order['timestamp']) // Assuming 'timestamp' is the field in your document
        .where('user.email', isEqualTo: order['user']['email']) // Replace 'user.email' with the actual field path
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var document in querySnapshot.docs) {
          document.reference.update({'type': 'success'});
        }
      } else {
        print('Order not found.');
      }
    });
  } catch (e) {
    print('Error updating order status: $e');
  
  }
}

}
