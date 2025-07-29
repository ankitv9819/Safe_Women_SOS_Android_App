import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart'; // Ensure you have this import

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _healthIssueController = TextEditingController();
  String? userId; // Store user ID

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load saved user data
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId'); // Get user ID from SharedPreferences
      _nameController.text = prefs.getString('fullName') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _phoneController.text = prefs.getString('phoneNumber') ?? '';
      _bloodGroupController.text = prefs.getString('bloodGroup') ?? '';
      _healthIssueController.text = prefs.getString('healthIssue') ?? '';
    });
  }

  // Function to update user profile via API
  Future<void> _updateUserProfile() async {
    String userId = "6"; // Manually set user ID

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _bloodGroupController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all mandatory fields!")),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    String apiUrl = 'http://192.168.238.78:8000/api/users/update/$userId';
    try {
      var response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "fullName": _nameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "confirmPassword": _confirmPasswordController.text,
          "phoneNumber": _phoneController.text,
          "bloodGroup": _bloodGroupController.text,
          "healthIssue": _healthIssueController.text,
        }),
      );

      if (response.statusCode == 200) {
        // **Save the updated data locally in SharedPreferences**
        _saveUserData();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update profile!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // **Function to save user data locally in SharedPreferences**
  void _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phoneNumber', _phoneController.text);
    await prefs.setString('bloodGroup', _bloodGroupController.text);
    await prefs.setString('healthIssue', _healthIssueController.text);
  }

  // Logout function (clears saved user data)
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to the login screen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("User Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildTextField("Full Name*", _nameController),
              _buildTextField("Email*", _emailController),
              _buildTextField("Password*", _passwordController,
                  obscureText: true),
              _buildTextField("Confirm Password*", _confirmPasswordController,
                  obscureText: true),
              _buildTextField("Phone No*", _phoneController,
                  keyboardType: TextInputType.phone),
              _buildTextField("Blood Group*", _bloodGroupController),
              _buildTextField(
                  "Health Issues (Optional)", _healthIssueController,
                  maxLines: 3),
              SizedBox(height: 20),

              // Centered Buttons
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _updateUserProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text("Update Profile",
                          style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text("Logout", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build text fields
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false,
      int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
