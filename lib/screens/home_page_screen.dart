import 'package:flutter/material.dart';
import 'business_login_page.dart';
import 'business_signup_page.dart';
import 'view_businesses_page.dart';
import 'orders_page.dart';

class HomePageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bridal Thrift'),
        backgroundColor: Colors.pink[200],
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Add your notification functionality here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[210],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Business Signup Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BusinessSignupPage()),
                        );
                      },
                      child: const Text(
                        'Sign up!',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Business Login Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BusinessLoginPage()),
                        );
                      },
                      child: const Text('Login as Business'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                '80% OFF WITH CODE: GCOMWELCOME',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Best Prices functionality
                    },
                    child: const Text('Best prices'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[100],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to View Businesses page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewBusinessesPage()),
                      );
                    },
                    child: const Text('View Businesses'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[100],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Orders page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrdersPage()),
                      );
                    },
                    child: const Text('Orders'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[100],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Most Popular',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8),
              children: List.generate(6, (index) {
                final productName = 'Wedding Dress ${index + 1}';
                final price = 4000 + (index * 1000);
                final imagePath = 'assets/images/wf${index + 1}.jpg'; // Path to the images

                return Card(
                  child: Column(
                    children: [
                      Image.asset(
                        imagePath, // Use Image.asset to display the local image
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          productName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'LKR $price.00',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.black),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          // Add your bottom navigation functionality here
        },
      ),
    );
  }
}
