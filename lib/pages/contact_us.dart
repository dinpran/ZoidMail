import 'package:flutter/material.dart';
import 'package:zoidmail/service/database_service.dart';

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
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Form validation
  bool _validateForm() {
    if (_subjectController.text.trim().isEmpty) {
      _showSnackBar("Please enter a subject", Colors.red);
      return false;
    }
    if (_emailController.text.trim().isEmpty) {
      _showSnackBar("Please enter your email", Colors.red);
      return false;
    }
    if (_messageController.text.trim().isEmpty) {
      _showSnackBar("Please enter your message", Colors.red);
      return false;
    }
    if (!_isNotRobot) {
      _showSnackBar("Please confirm you are not a robot", Colors.red);
      return false;
    }
    return true;
  }

  // Submit form
  void _submitForm() async {
    if (!_validateForm()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      DatabaseService databaseService = DatabaseService();

      bool success = await databaseService.submitContactForm(
        subject: _subjectController.text.trim(),
        email: _emailController.text.trim(),
        message: _messageController.text.trim(),
      );

      if (success) {
        _showSnackBar(
            "Message submitted successfully! We'll get back to you soon.",
            Colors.green);
        _clearForm();
      } else {
        _showSnackBar(
            "Failed to submit message. Please try again.", Colors.red);
      }
    } catch (e) {
      _showSnackBar("An error occurred. Please try again.", Colors.red);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  // Clear form
  void _clearForm() {
    _subjectController.clear();
    _emailController.clear();
    _messageController.clear();
    setState(() {
      _isNotRobot = false;
    });
  }

  // Show snackbar
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
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
                labelText: "Subject*",
                counterText: "${_subjectController.text.length}/30",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {}); // Update counter
              },
            ),
            const SizedBox(height: 16),
            // Email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Your Email* (Required for response)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Message Field
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Message*",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Checkbox and Submit Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isNotRobot,
                        onChanged: (value) {
                          setState(() {
                            _isNotRobot = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text("I am not a robot"),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text("SUBMIT"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Required fields note
            const Text(
              "* Required fields",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
