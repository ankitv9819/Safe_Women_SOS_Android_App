import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  // Function to open the URL
  void _launchURL() async {
  final Uri url = Uri.parse("https://www.womenssdc.com/about.html");
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw "Could not launch $url";
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Our Services"),
      backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Empowering Women Through Self-Defense",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Image(
              image: AssetImage("assets/self_defence.jpg"),
              width: double.infinity,
              height: 250,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              "We provide self-defense workshops and training to empower women. "
              "Our sessions cover:\n\n"
              "✔️ Physical self-defense techniques\n"
              "✔️ Emergency response training\n"
              "✔️ Situational awareness\n"
              "✔️ Mental resilience\n"
              "✔️ Personal safety strategies\n\n"
              "Join us to enhance your confidence and security!",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: Text("Back to Home"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _launchURL,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Different color for distinction
                foregroundColor: Colors.white,
              ), // Calls the function to open the link
              child: Text("Events"),
            ),
          ],
        ),
      ),
    );
  }
}
