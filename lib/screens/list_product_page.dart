import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ListProductPage extends StatefulWidget {
  @override
  _ListProductPageState createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _takePictureWithCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _listProduct() async {
    if (_imageFile == null ||
        _nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields and pick an image.')),
      );
      return;
    }

    final uri = Uri.parse('http://10.0.2.2:8000/api/products');
    final request = http.MultipartRequest('POST', uri);

    request.fields['name'] = _nameController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['quantity'] = _quantityController.text;
    request.fields['price'] = _priceController.text;
    request.fields['business_id'] = '1'; // Replace with actual business ID

    request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));

    final response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product listed successfully!')),
      );
      Navigator.pop(context);
    } else {
      final errorMessage = await response.stream.bytesToString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $errorMessage')),
      );
    }
  }

  void _openLocationInMaps() async {
    // Coordinates for Colombo, Sri Lanka
    final String location = 'Colombo, Sri Lanka';
    final Uri launchUri = Uri(
      scheme: 'geo',
      path: '6.9271,79.8612?q=$location', // Latitude and Longitude
    );

    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List a Product')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Button to pick image from gallery
              ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: Text('Pick Image from Gallery'),
              ),
              // Button to take picture using camera
              ElevatedButton(
                onPressed: _takePictureWithCamera,
                child: Text('Take Picture with Camera'),
              ),
              _imageFile != null
                  ? Image.file(File(_imageFile!.path), height: 150)
                  : Container(),
              // Text fields for product details
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              // Button to open Google Maps
              ElevatedButton(
                onPressed: _openLocationInMaps,
                child: Text('Open Location in Google Maps'),
              ),
              SizedBox(height: 21),
              // Button to list the product
              ElevatedButton(
                onPressed: _listProduct,
                child: Text('List Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}