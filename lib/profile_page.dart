import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kojiq3/photo_up.dart'; // Add this line

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _errorMessage = '';

  Future<void> _saveProfile() async {
    try {
      final user = _auth.currentUser;
      print('User: $user'); // Debug statement
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'address': _addressController.text,
          'age': int.parse(_ageController.text),
        });
        print('Profile saved successfully'); // Debug statement
        // Profile information saved, navigate to ImageUploadPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageUploadPage()),
        );
      } else {
        print('User is null');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save'),
            ),
            if (_errorMessage.isNotEmpty) ...[
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}