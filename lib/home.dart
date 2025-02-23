import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  void sendHelpMessage() {
    print("Help message sent!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety App'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings'); // Named Route
            },
          ),
        ],
      ),
      body: GestureDetector(
        onDoubleTap: sendHelpMessage, // Double Tap Gesture
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/safety_image.png', width: 150),
              SizedBox(height: 20),
              Text(
                "Emergency Assistance",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  print("Calling emergency number...");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text("Emergency Call", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: sendHelpMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text("Send Help Message", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
