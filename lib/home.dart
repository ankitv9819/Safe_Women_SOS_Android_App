import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'community.dart'; // Import the Community page
import 'services.dart'; // Import the Services page
import 'feedback.dart'; // Import the Feedback page
import 'profile.dart'; // Import the Profile page
import 'contact_list.dart'; // Import the Contact List
import 'user_guide.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void sendSOS(BuildContext context) {
    print("SOS button pressed!");
    _sendSOSMessage(context);
    makeSOSCall(context);
  }

  Future<void> makeSOSCall(BuildContext context) async {
    const accountSid = "ACxxxxxxxxxxxxxxxxxxxxx";
    const authToken = "33xxxxxxxxxxxxxxxxxxxxxx";
    const from = "+15xxxxxxxxx"; // Twilio Number
    const to = "+91xxxxxxxxx"; // Emergency Contact Number

    final String basicAuth =
        'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}';

    final response = await http.post(
      Uri.parse(
          'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Calls.json'),
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'From': from,
        'To': to,
        'Twiml':
            '<Response><Say>This is an emergency call. Stay safe.</Say></Response>',
      },
    );

    if (response.statusCode == 201) {
      print("✅ Call initiated successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Emergency Call Initiated!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      print("❌ Error: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Failed to initiate the call."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendSOSMessage(BuildContext context) async {
    String location = await _getCurrentLocation();
    String message =
        "🚨🚨SOS Alert!🚨🚨 I AM IN TROUBLE, NEED HELP. Here is my location:$location";

    String twilioAccountSid = "ACxxxxxxxxxxxxxxxxxxxxx";
    String twilioAuthToken = "33xxxxxxxxxxxxxxxxxxxxxx";
    String twilioPhoneNumber = "+15xxxxxxxxx";
    String emergencyContact = "+91xxxxxxxxxx"; // Change to actual number

    try {
      var response = await http.post(
        Uri.parse(
            'https://api.twilio.com/2010-04-01/Accounts/$twilioAccountSid/Messages.json'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$twilioAccountSid:$twilioAuthToken'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'From': twilioPhoneNumber,
          'To': emergencyContact,
          'Body': message,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("🚀 SOS Message Sent Successfully!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ SOS Message Sent Successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print("⚠️ Failed to send SOS message: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ Failed to send SOS message."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("❌ Error sending SOS: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error sending SOS!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return "Location permission denied.";
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      String googleMapsLink =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

      return "📍 Location: $googleMapsLink";
    } catch (e) {
      return "⚠️ Failed to get location: $e";
    }
  }

  Future<void> makeEmergencyCall(BuildContext context, String to) async {
    const accountSid = "ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    const authToken = "33xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    const from = "+15xxxxxxxxxx"; // Twilio Number

    final String basicAuth =
        'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}';

    final response = await http.post(
      Uri.parse(
          'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Calls.json'),
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'From': from,
        'To': to,
        'Twiml':
            '<Response><Say>This is an emergency call to $to.</Say></Response>',
      },
    );

    if (response.statusCode == 201) {
      print("✅ Emergency call initiated to $to!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Emergency Call Initiated to $to!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      print("❌ Error: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Failed to initiate call."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/app_icon.png', // ✅ Change to your logo path
              height: 70, // Adjusted for better fit
            ),
            Text(
              " Safe Women", // Kept minimal spacing
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.pink, // ✅ Set AppBar color
        elevation: 0, // ✅ Remove AppBar shadow
        actions: [
          IconButton(
            icon: Icon(Icons.feedback),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle), // Profile Icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.shield),
              title: Text('Services'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ServicesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Community'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommunityPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Emergency Contacts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactListPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('User Guide'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserGuidePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            height: 130,
            child: ElevatedButton(
              onPressed: () =>
                  sendSOS(context), // ✅ FIXED: Pass context properly
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                // Ambulance call
                SizedBox(
                  width: 250,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () => makeEmergencyCall(
                        context, "+91xxxxxxxxxx"), // 🚑 Calls 108 via Twilio
                    child: Text("Ambulance - 108"),
                  ),
                ),

                SizedBox(height: 15),
                // GAs Leak Call
                SizedBox(
                  width: 250,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () =>
                        makeEmergencyCall(context, "+911906"), // 🔥 Gas Leak
                    child: Text("Gas Leak - 1906"),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () => makeEmergencyCall(
                        context, "+91104"), // 🌪 Disaster Management
                    child: Text("Disaster Management - 104"),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () =>
                        makeEmergencyCall(context, "+91100"), // 🚔 Police
                    child: Text("Police - 100"),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: 250,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () => makeEmergencyCall(
                        context, "+91104"), // 🚒 Fire Department
                    child: Text("Fire Management - 104"),
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
