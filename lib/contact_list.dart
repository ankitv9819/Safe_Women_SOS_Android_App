import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<Map<String, String>> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts(); // Load contacts when the page opens
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedContacts = prefs.getString('contacts');
    
    if (storedContacts != null) {
      setState(() {
        contacts = List<Map<String, String>>.from(
          jsonDecode(storedContacts).map((item) => Map<String, String>.from(item)),
        );
      });
    }
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('contacts', jsonEncode(contacts));
  }

  Future<void> _addContact() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both name and phone number.")),
      );
      return;
    }

    try {
      var response = await http.post(
        Uri.parse("http://192.168.238.78:8000/api/contact/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"contactName": name, "contactNumber": phone}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          contacts.add({"contactName": name, "contactNumber": phone});
        });

        _saveContacts(); // Save contacts locally
        _nameController.clear();
        _phoneController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add contact. Try again!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _deleteContact(int index) async {
    int contactId = 6; // Manually set ID for deletion

    try {
      var response = await http.delete(
        Uri.parse("http://192.168.238.78:8000/api/contact/delete/$contactId"),
      );

      if (response.statusCode == 200) {
        setState(() {
          contacts.removeAt(index);
        });

        _saveContacts(); // Update stored contacts after deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Contact deleted successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete contact. Try again!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Contacts"),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Add an Emergency Contact",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Contact Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Contact Number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: _addContact,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("Add Contact", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Text(
              "Saved Contacts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Expanded(
              child: contacts.isEmpty
                  ? Center(child: Text("No contacts added yet."))
                  : ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(
                              contacts[index]['contactName']!,
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              contacts[index]['contactNumber']!,
                              textAlign: TextAlign.center,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteContact(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
