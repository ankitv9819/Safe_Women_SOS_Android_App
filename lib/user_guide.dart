import 'package:flutter/material.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Guide"),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildGuideSection(
              title: "👤 Access Profile & Add Profile",
              steps: [
                "1. Open the profile page by tapping the profile icon on right corner.",
                "2. Fill in your details (Name, Email, etc.).",
                "3. Click 'Save Details' to store your profile.",
              ],
            ),
            _buildGuideSection(
              title: "🛠 Access Services & View Events",
              steps: [
                "1. Open the sidebar menu click this ☰ icon.",
                "2. Click on 'Services'.",
                "3. Browse through the available safety services and upcoming events.",
              ],
            ),
            _buildGuideSection(
              title: "🌍 Access Community & Post Thoughts",
              steps: [
                "1. Open the sidebar menu.",
                "2. Click on 'Community'.",
                "3. Read posts from other users.",
                "4. To post your thoughts, type your message and click 'Post'.",
              ],
            ),
            _buildGuideSection(
              title: "📞 Add Emergency Contact",
              steps: [
                "1. Open the sidebar menu.",
                "2. Select 'Emergency Contacts'.",
                "3. Enter Contact Name and Contact No.",
                "4. Click 'Add Contact' to save.",
              ],
            ),
            _buildGuideSection(
              title: "📝 Submitting Feedback",
              steps: [
                "1. Open the Feeback page by tapping the Feedback icon on right corner.",
                "2. Enter your feedback in the provided text field.",
                "3. Click 'Submit' to send your feedback.",
              ],
            ),
            _buildGuideSection(
              title: "🚨 Accessing Helpline Numbers",
              steps: [
                "1. On the Home Page, scroll down to find the Helpline Section.",
                "2. Tap on the relevant helpline button (Ambulance, Police, etc.).",
                "3. Your phone will automatically dial the selected helpline number.",
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSection({required String title, required List<String> steps}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: steps
                  .map((step) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text("• $step"),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
