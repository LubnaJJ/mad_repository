import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'purchase_confirmation_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class BusinessDetailPage extends StatefulWidget {
  final int businessId;
  final String businessName;

  BusinessDetailPage({required this.businessId, required this.businessName});

  @override
  _BusinessDetailPageState createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<BusinessDetailPage> {
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/products?business_id=${widget.businessId}'));
      if (response.statusCode == 200) {
        setState(() {
          _products = json.decode(response.body);
        });
      } else {
        print('Failed to load products: ${response.body}');
      }
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isNotEmpty) {
      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
      try {
        if (await canLaunch(launchUri.toString())) {
          await launch(launchUri.toString());
        } else {
          print('Could not launch $launchUri');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not make the call.')),
          );
        }
      } catch (e) {
        print('Error making call: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error making the call.')),
        );
      }
    } else {
      print('Phone number is empty');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid phone number.')),
      );
    }
  }

  void _openLocation() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      final Uri launchUri = Uri(scheme: 'geo', path: '0,0?q=Business+Location'); // Replace with actual location
      if (await canLaunch(launchUri.toString())) {
        await launch(launchUri.toString());
      } else {
        throw 'Could not launch $launchUri';
      }
    } else {
      await Permission.location.request();
    }
  }

  void _sendSMS(String message) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: '',
      queryParameters: <String, String>{'body': message},
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.businessName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Image
            Container(
              height: isPortrait ? 150 : 100, // Adjust height based on orientation
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/wf3.jpg'), // Use your background image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Business Name
            Center(
              child: Text(
                widget.businessName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            // Functionality Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.call),
                  onPressed: () => _makePhoneCall('1234567890'), // Replace with actual phone number
                  tooltip: 'Call',
                ),
                IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: _openLocation,
                  tooltip: 'Location',
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () => _sendSMS('Hello! I want to inquire about your products.'),
                  tooltip: 'Send SMS',
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'View Listed Items',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _products.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isPortrait ? 2 : 3, // Change the number of columns based on orientation
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.60,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.network(
                            product['image'] ?? 'https://via.placeholder.com/150',
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://via.placeholder.com/150',
                                height: 150,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        // Product Details
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'] ?? 'Unnamed Product',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Text(
                                product['description'] ?? 'No description available',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Qty: ${product['quantity'] ?? 0}',
                                    style: TextStyle(color: Colors.green, fontSize: 14),
                                  ),
                                  Text(
                                    'LKR ${product['price'] ?? 'N/A'}',
                                    style: TextStyle(color: Colors.red, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Purchase Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PurchaseConfirmationPage(product: product),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Purchase'),
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
      ),
    );
  }
}