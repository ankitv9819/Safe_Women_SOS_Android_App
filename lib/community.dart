import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _postController = TextEditingController();
  List<Map<String, String>> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedPosts = prefs.getStringList('community_posts');

    if (savedPosts != null) {
      setState(() {
        _posts = savedPosts.map((post) {
          List<String> splitPost = post.split('|');
          if (splitPost.length == 2) {
            return {"email": splitPost[0], "message": splitPost[1]};
          } else {
            return {"email": "Unknown", "message": post};
          }
        }).toList();
      });
    }
  }

  Future<void> _savePosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> formattedPosts =
        _posts.map((post) => "${post['email']}|${post['message']}").toList();
    await prefs.setStringList('community_posts', formattedPosts);
  }

  Future<void> _addPost() async {
    String email = _emailController.text.trim();
    String message = _postController.text.trim();

    if (email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both email and message")),
      );
      return;
    }

    try {
      var response = await http.post(
        Uri.parse("http://192.168.238.78:8000/api/community/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "message": message}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _posts.insert(0, {"email": email, "message": message});
        });
        _savePosts();
        _emailController.clear();
        _postController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to post. Try again!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

Future<void> _deletePost(int index) async {
  int postId = 9; // Manually set ID for deletion

  try {
    var response = await http.delete(
      Uri.parse("http://192.168.238.78:8000/api/community/$postId"),
    );

    if (response.statusCode == 200) {
      setState(() {
        _posts.removeAt(index);
      });

      _savePosts(); // Update stored posts after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Post deleted successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete post. Try again!")),
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
        title: Text("Community Updates"),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Legislative Measures & Women's Safety Updates",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.pink, width: 1),
              ),
              child: Text(
                "Legislative Measures\n\n"
                "The Indian government has taken significant steps to improve women’s safety through various laws and initiatives."
                " One of the key measures is the Nirbhaya Fund, established to support projects aimed at enhancing women’s safety."
                " Additionally, the Criminal Law (Amendment) Act, 2018 introduced stricter penalties for sexual offenses."
                " The Women Safety Division was established on May 28, 2018, to enhance security for women.\n\n"
                "Specialized Helplines and Support Centers\n\n"
                "✔️ 181 Women Helpline: A 24-hour emergency response service.\n"
                "✔️ One Stop Centers: Providing medical, legal, and psychological assistance.\n"
                "✔️ Cybercrime Portal: A platform for reporting online harassment.\n\n"
                "Public Awareness Campaigns\n\n"
                "✔️ Mission Shakti: A campaign for women empowerment and rights awareness.\n"
                "✔️ Online Movements: Initiatives like #MeToo encouraging women to speak out.\n"
                "✔️ Educational Programs: Gender sensitization in schools and colleges.\n\n"
                "The government’s commitment is evident, but challenges remain in effective implementation.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Share Your Thoughts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: "Enter your email...",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _postController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: "Write your post...",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: Text("Post"),
            ),
            SizedBox(height: 20),
            Text(
              "Community Posts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            _posts.isEmpty
                ? Text(
                    "No posts yet. Be the first to share your thoughts!",
                    textAlign: TextAlign.center,
                  )
                : Column(
                    children: _posts
                        .asMap()
                        .entries
                        .map((entry) => Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              color: Colors.pink[50],
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "📧 ${entry.value['email']}",
                                      style: TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      entry.value['message']!,
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deletePost(entry.key),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
