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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SETTINGS PAGE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              authServices.signout();
              nextScreenReplacement(context, LoginPage());
            },
            child: Text("Signout")),
      ),
    );
  }
}
