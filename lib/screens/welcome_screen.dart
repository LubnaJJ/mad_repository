// screens/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
  }

  Future<void> _getBatteryLevel() async {
    final int level = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate 3/4th of the screen width for button size
    final double buttonWidth = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/banner.jpg'), // Adjust the path as needed
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content (Logo, Text, and Buttons)c
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo (add your logo image)
                Image.asset(
                  'assets/images/shop.icon.png', // Adjust the path as needed
                  height: 140, // Adjust size as needed
                ),
                SizedBox(height: 21), // Space between logo and text

                // Welcome text
                Text(
                  'Welcome to Bridal Thrift',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Make text white for visibility on background
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20), // Space between welcome text and battery info

                // Battery Level Display
                Text(
                  'Battery Level: $_batteryLevel%',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Text color for visibility
                  ),
                ),
                SizedBox(height: 60),

                // Login Button
                SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login'); // Navigate to Login Screen
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.white, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black, // Button text color
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Signup Button
                SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup'); // Navigate to Signup Screen
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.white, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black, // Button text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}