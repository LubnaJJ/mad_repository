import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'orders_page.dart'; // Import the OrdersPage

class PurchaseConfirmationPage extends StatelessWidget {
  final dynamic product;

  PurchaseConfirmationPage({required this.product});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? bankAccountNumber, cvv;

    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display Product Details
            Text(
              product['name'] ?? 'Unnamed Product',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Price: LKR ${product['price'] ?? 'N/A'}'),
            Text('Description: ${product['description'] ?? 'No description available'}'),
            SizedBox(height: 20),

            // Payment Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Bank Account Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your bank account number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      bankAccountNumber = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'CVV'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 3) {
                        return 'Please enter a valid CVV';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      cvv = value;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Call a method to handle the purchase
                        await _handlePurchase(
                          product['id'],
                          bankAccountNumber,
                          cvv,
                          product['price'], // Ensure this is the correct amount
                          context, // Pass context for showing SnackBars
                        );
                      }
                    },
                    child: Text('Buy Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePurchase(int productId, String? bankAccountNumber, String? cvv, dynamic amount, BuildContext context) async {
    // Call your backend API to save the order
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/purchase'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "product_id": productId,
          "bank_account_number": bankAccountNumber,
          "cvv": cvv,
          "amount": amount, // Amount should be included
          "customer_id": 1, // This should be the actual customer ID from your app
        }),
      );

      // Log the response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // If successful, show a confirmation message and navigate to OrdersPage
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrdersPage()), // Navigate to OrdersPage
        );
      } else {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: ${response.body}')),
        );
      }
    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
}