import 'package:flutter/material.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_page_screen.dart'; // Import the new home page screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bridal Gown Rental',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Set the WelcomeScreen as the initial route
      routes: {
        '/': (context) => WelcomeScreen(), // Welcome screen as initial screen
        '/login': (context) => LoginScreen(), // Login screen route
        '/signup': (context) => SignupScreen(), // Signup screen route
        '/home': (context) => HomePageScreen(), // Updated to new HomePageScreen
      },
    );
  }
}
