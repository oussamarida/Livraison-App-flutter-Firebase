import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:last_livrai/screens/pages/list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class OrderItem {
  final String name;
  final String image;
  final double price;
  int quantity; // Add quantity field

  OrderItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity, // Require quantity to be provided
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
        quantity:
            json['quantity'] ?? 1, 
      );
}

class Category {
  final String name;
  final String image;
  
  final List<FoodItem> foods;

  Category({required this.name, required this.image, required this.foods});
}

class FoodItem {
  final String name;
  final String description;
  final double price;
  final String image;

  FoodItem(
      {required this.name,
      required this.description,
      required this.price,
      required this.image});
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int selectedCategoryIndex = -1; 
final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

Future<void> saveOrder(OrderItem newOrder) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> ordersStringList = prefs.getStringList('orders') ?? [];
  final List<OrderItem> orders = [];

  // Convert the stored order strings back to OrderItem objects
  for (final orderString in ordersStringList) {
    try {
      final order = OrderItem.fromJson(jsonDecode(orderString));
      orders.add(order);
    } catch (e) {
      print('Error decoding order: $e');
    }
  }

  final existingOrderIndex = orders.indexWhere((order) => order.name == newOrder.name);

  if (existingOrderIndex != -1) {
    orders[existingOrderIndex].quantity += newOrder.quantity;
  } else {
    orders.add(newOrder);
  }

  final updatedOrdersStringList = orders.map((order) => jsonEncode(order.toJson())).toList();
  await prefs.setStringList('orders', updatedOrdersStringList);
  print('Order saved: ${newOrder.name}, ${newOrder.price}');
}

  @override
  Widget build(BuildContext context) {
    final List<Category> categories = loadCategories();

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
            child: Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      width: 160,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Image.network(
                              categories[index].image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Text(
                              categories[index].name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: selectedCategoryIndex == -1
                  ? categories
                      .map((category) => category.foods.length)
                      .reduce((a, b) => a + b)
                  : categories[selectedCategoryIndex].foods.length,
              itemBuilder: (context, index) {
                FoodItem? food;
                if (selectedCategoryIndex == -1) {
                  int categoryIndex = 0;
                  int foodIndex = index;
                  for (var category in categories) {
                    if (foodIndex < category.foods.length) {
                      food = category.foods[foodIndex];
                      break;
                    } else {
                      foodIndex -= category.foods.length;
                      categoryIndex++;
                    }
                  }
                } else {
                  food = categories[selectedCategoryIndex].foods[index];
                }
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.network(
                          food!.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                food.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                food.description,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '${food.price.toStringAsFixed(2)} \$',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                 ElevatedButton(
                                onPressed: () async { 
                                  var order = OrderItem(name: food!.name, price:food.price , image:food.image , quantity: 1);
                                  await saveOrder(order);
                                },
                                child: Text('Order'),
                              )
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
        ],
      ),
    );
  }
}


