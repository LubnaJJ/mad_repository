import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/orders?customer_id=1')); // Adjust API endpoint accordingly
      if (response.statusCode == 200) {
        setState(() {
          _orders = json.decode(response.body);
        });
      } else {
        print('Failed to load orders: ${response.body}');
      }
    } catch (error) {
      print('Error fetching orders: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _orders.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, index) {
            final order = _orders[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(order['product_name'] ?? 'Unnamed Product'),
                subtitle: Text('Price: LKR ${order['amount']}'),
                trailing: Text('Qty: ${order['quantity']}'), // Assuming you have quantity in your orders
              ),
            );
          },
        ),
      ),
    );
  }
}