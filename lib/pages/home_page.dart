import 'package:flutter/material.dart';
import 'package:zoidmail/auth/login_page.dart';
import 'package:zoidmail/service/auth_service.dart';
import 'package:zoidmail/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HomePage",
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
