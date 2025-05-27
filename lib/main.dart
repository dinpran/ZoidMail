import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zoidmail/auth/login_page.dart';
import 'package:zoidmail/helper/helper_functions.dart';
import 'package:zoidmail/pages/home_page.dart';
import 'package:zoidmail/shared/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool isSignedin = false;
  @override
  void initState() {
    // TODO: implement initState
    getuserloggedinstatus();
    super.initState();
  }

  getuserloggedinstatus() async {
    await HelperFunctions.userloggedinstatus().then((value) {
      if (value != null) {
        setState(() {
          isSignedin = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: isSignedin ? HomePage() : LoginPage(),
    );
  }
}
