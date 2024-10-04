import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'business_detail_page.dart';

class ViewBusinessesPage extends StatefulWidget {
  @override
  _ViewBusinessesPageState createState() => _ViewBusinessesPageState();
}

class _ViewBusinessesPageState extends State<ViewBusinessesPage> {
  List<dynamic> _businesses = [];

  @override
  void initState() {
    super.initState();
    _fetchBusinesses();
  }

  Future<void> _fetchBusinesses() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/businesses'));

    if (response.statusCode == 200) {
      print('API Response: ${response.body}');

      setState(() {
        _businesses = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load businesses')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and orientation
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(title: Text('Businesses')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isLandscape ? 32 : 16), // Adjust padding based on orientation
        child: _businesses.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _businesses.length,
          itemBuilder: (context, index) {
            final business = _businesses[index];

            print('Business Data: $business');

            final businessName = business['business_name'] ?? 'No name provided';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: isLandscape ? Colors.blue : Colors.pink[50], // Change color based on orientation
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded( // Make the text expand to use available space
                        child: Text(
                          businessName,
                          style: TextStyle(
                            fontSize: screenWidth > 600 ? 22 : 18, // Adjust font size based on screen width
                            fontWeight: FontWeight.bold,
                            color: isLandscape ? Colors.white : Colors.pink[900], // Change text color based on orientation
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusinessDetailPage(
                                businessId: business['id'],
                                businessName: businessName,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('View Details'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}