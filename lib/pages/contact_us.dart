import 'package:flutter/material.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  // Controllers for form fields
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isNotRobot = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Us",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Add notification functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introductory Text
            const Text(
              "If you have question, suggestions, or anything else feel free to contact us.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            // Subject Field
            TextField(
              controller: _subjectController,
              maxLength: 30,
              decoration: InputDecoration(
                labelText: "Subject",
                counterText: "${_subjectController.text.length}/30",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white, // Light blue background
              ),
            ),
            const SizedBox(height: 16),
            // Email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Your Email (If u need an answer)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white, // Light blue background
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Message Field
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white, // Light blue background
              ),
            ),
            const SizedBox(height: 16),
            // Checkbox and Submit Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _isNotRobot,
                      onChanged: (value) {
                        setState(() {
                          _isNotRobot = value ?? false;
                        });
                      },
                    ),
                    const Text("I am not a robot"),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add submit functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("SUBMIT"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
