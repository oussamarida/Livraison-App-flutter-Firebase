import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last_livrai/screens/pages/mapsScreen.dart';

class Order extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
        ),
        body: Center(
          child: Text('User not signed in.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('user.email', isEqualTo: user.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No orders found for user: ${user.email}'),
            );
          }
          List<Map<String, dynamic>> ordersData = snapshot.data!.docs
              .map((document) => document.data() as Map<String, dynamic>)
              .toList();
          List<Widget> orderCards = ordersData.map((data) {
            List<Map<String, dynamic>> orderItems =
                (data['orders'] as List<dynamic>)
                    .cast<Map<String, dynamic>>();
            Color cardColor;
            switch (data['type']) {
              case 'pending':
                cardColor = Colors.grey; // Gray for pending orders
                break;
              case 'delivered':
                cardColor = Colors.green; // Green for delivered orders
                break;
              case 'refused':
                cardColor = Colors.red; // Red for refused orders
                break;
              case 'coming':
                cardColor = Colors.blue; // Blue for coming orders (you can choose a different color)
                break;
              default:
                cardColor = Colors.grey; // Default to gray for unknown status
            }

            // Calculate the total price for each order
            double total = orderItems.fold(
              0,
              (previousValue, item) => previousValue + item['price'] * item['quantity'],
            );

            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: cardColor, // Set card color based on status
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User: ${data['user']['email'] ?? ''}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        for (var item in orderItems)
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
                          'Total: \$${total.toStringAsFixed(2)}', // Display the total for each order
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Timestamp: ${data['timestamp'].toDate()}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  
                  // Button to view on map (only for 'coming' orders)
                  if (data['type'] == 'coming')
                    Center(
                      child: Container(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the map screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(),
                              ),
                            );
                          },
                          child: Text('View on Map'),
                        ),
                      ),
                    ),
                  SizedBox(height: 12),
                ],
              ),
            );
          }).toList();

          return ListView(
            children: orderCards,
          );
        },
      ),
    );
  }
}
