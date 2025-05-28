import 'package:flutter/material.dart';
import 'package:zoidmail/auth/login_page.dart';
import 'package:zoidmail/service/auth_service.dart';
import 'package:zoidmail/widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AuthServices authServices = AuthServices();
  bool _darkMode = false; // State for the dark mode toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SETTINGS",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "ADMIN SETTINGS",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Dark Mode Setting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("DARK MODE"),
              Switch(
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
              ),
            ],
          ),
          const Divider(),

          // Pause/Extend Inbox Lifespan
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("PAUSE/EXTEND INBOX LIFESPAN"),
          ),
          const Divider(),

          // Custom Email Generation
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("CUSTOM EMAIL GENERATION"),
          ),
          const Divider(),

          // Enable Recovery Key
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("ENABLE RECOVERY KEY"),
          ),
          const Divider(),

          // Email Forwarding
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("EMAIL FORWARDING"),
          ),
          const Divider(),

          // Signout Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                authServices.signout();
                nextScreenReplacement(context, const LoginPage());
              },
              child: const Text("Signout"),
            ),
          ),
        ],
      ),
    );
  }
}
