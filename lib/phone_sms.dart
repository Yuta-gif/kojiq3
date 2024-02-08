import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kojiq3/register_page.dart'; // Add this line

class SmsAuthPage extends StatefulWidget {
  @override
  _SmsAuthPageState createState() => _SmsAuthPageState();
}

class _SmsAuthPageState extends State<SmsAuthPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String _verificationId='';
  bool _isPhoneNumberSubmitted = false;
  String _errorMessage = '';

  Future<void> _submitPhoneNumber() async {
    // Convert the phone number to E.164 format
    String phoneNumber = _phoneController.text.replaceAll('-', '');
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+81' + phoneNumber.substring(1);
    }

    // Validate the phone number
    if (!phoneNumber.startsWith('+81')) {
      setState(() {
        _errorMessage = 'Invalid country code. Only Japanese phone numbers are allowed.';
      });
      return;
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Error: $e');
          // Handle invalid phone number or other errors
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          setState(() {
            _isPhoneNumberSubmitted = true;
            _errorMessage = ''; // Clear the error message here
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _submitSmsCode() async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _codeController.text,
    );

    try {
      await _auth.signInWithCredential(credential);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
    } catch (e) {
      print('Error: $e');
      // Handle invalid SMS code or other errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SMS Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone number'),
            ),
            if (_errorMessage.isNotEmpty) ...[
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
            ElevatedButton(
              onPressed: _submitPhoneNumber,
              child: Text('Submit phone number'),
            ),
            if (_isPhoneNumberSubmitted) ...[
              TextField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'SMS code'),
              ),
              ElevatedButton(
                onPressed: _submitSmsCode,
                child: Text('Submit SMS code'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}