import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _healthIssueController = TextEditingController();
  String? _selectedBloodGroup;

  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
  ];

  Future<void> _signUp() async {
  if (_formKey.currentState!.validate()) {
    Map<String, dynamic> requestBody = {
      "fullName": _fullNameController.text.trim(),
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
      "confirmPassword": _confirmPasswordController.text,
      "phoneNumber": _phoneNumberController.text.trim(),
      "healthIssue": _healthIssueController.text.trim().isEmpty ? null : _healthIssueController.text.trim(),
      "gender": "F",  // Change based on user selection
      "bloodGroup": _selectedBloodGroup
    };

    try {
      var response = await http.post(
        Uri.parse('http://192.168.238.78:8000/api/users/create'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup successful! Please log in.")),
        );
        Navigator.pop(context);
      } else {
        var errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup : ${errorResponse['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up"), backgroundColor: Colors.pink),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add, size: 80, color: Colors.pink),
                  SizedBox(height: 20),
                  Text("Create an Account",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink.shade800)),
                  SizedBox(height: 10),
                  Text("Sign up to get started", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  SizedBox(height: 30),

                  // Full Name
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person, color: Colors.pink),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: (value) => value == null || value.isEmpty ? "Please enter your full name" : null,
                  ),
                  SizedBox(height: 15),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email, color: Colors.pink),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: (value) => value == null || value.isEmpty ? "Please enter your email" : null,
                  ),
                  SizedBox(height: 15),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, color: Colors.pink),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Please enter your password";
                      if (value.length < 6) return "Password must be at least 6 characters";
                      return null;
                    },
                  ),
                  SizedBox(height: 15),

                  // Confirm Password
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.pink),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Please confirm your password";
                      if (value != _passwordController.text) return "Passwords do not match";
                      return null;
                    },
                  ),
                  SizedBox(height: 15),

                  // Phone Number
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: Icon(Icons.phone, color: Colors.pink),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Please enter your phone number";
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) return "Enter a valid 10-digit phone number";
                      return null;
                    },
                  ),
                  SizedBox(height: 15),

                  // Health Issue
                  TextFormField(
                    controller: _healthIssueController,
                    decoration: InputDecoration(
                      labelText: "Health Issue (if any)",
                      prefixIcon: Icon(Icons.local_hospital, color: Colors.pink),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Blood Group Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedBloodGroup,
                    decoration: InputDecoration(
                      labelText: "Blood Group",
                      prefixIcon: Icon(Icons.bloodtype, color: Colors.pink),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    items: _bloodGroups.map((bloodGroup) => DropdownMenuItem(value: bloodGroup, child: Text(bloodGroup))).toList(),
                    onChanged: (value) => setState(() => _selectedBloodGroup = value),
                    validator: (value) => value == null ? "Please select your blood group" : null,
                  ),
                  SizedBox(height: 20),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  SizedBox(height: 10),

                  // Login Link
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Already have an account? Login", style: TextStyle(color: Colors.pink, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
