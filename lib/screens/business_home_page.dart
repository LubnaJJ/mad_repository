import 'package:flutter/material.dart';
import 'list_product_page.dart'; // Import your ListProductPage
import 'view_orders_page.dart';  // Import your ViewOrdersPage
import 'business_info_page.dart'; // Import your BusinessInfoPage
import 'view_listed_items_page.dart'; // Adjust the path as necessary

class BusinessHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen width and orientation
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text('Business Home'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isLandscape ? 32 : 16), // Adjust padding based on orientation
        child: GridView.count(
          crossAxisCount: isLandscape ? 2 : 1, // Two cards per row in landscape, one in portrait
          childAspectRatio: 3 / 1, // Adjust aspect ratio for better appearance
          children: [
            _buildCard(context, 'List a Product', ListProductPage()),
            _buildCard(context, 'View Orders', ViewOrdersPage()),
            _buildCard(context, 'Business Info', BusinessInfoPage()),
            _buildCard(context, 'View Listed Items', ViewListedItemsPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget page) {
    // Check if in landscape to set color
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        color: isLandscape ? Colors.blue : Colors.white, // Change color based on orientation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width > 600 ? 20 : 16, // Adjust font size based on screen width
                color: isLandscape ? Colors.white : Colors.black, // Change text color for better visibility
              ),
            ),
          ),
        ),
      ),
    );
  }
}