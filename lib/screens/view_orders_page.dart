import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewOrdersPage extends StatefulWidget {
  @override
  _ViewOrdersPageState createState() => _ViewOrdersPageState();
}

class _ViewOrdersPageState extends State<ViewOrdersPage> {
  List<dynamic> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8000/api/orders?customer_id=1')); // Adjust the URL to include customer ID
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
      appBar: AppBar(title: Text('View Orders')),
      body: _orders.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return ListTile(
            title: Text('Product: ${order['product_name']}'),
            // Change according to your API response
            subtitle: Text('Price: LKR ${order['amount']}'),
          );
        },
      ),
    );
  }
}