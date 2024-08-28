import 'package:easy_first_aid/screens/homescreen.dart';
import 'package:easy_first_aid/screens/login.dart';
import 'package:easy_first_aid/screens/signup.dart';
import 'package:easy_first_aid/screens/startScreen.dart';
import 'package:easy_first_aid/screens/symptomscheck.dart';
import 'package:flutter/material.dart';
// import 'package:swipeable_button_view/swipeable_button_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Startscreen(),
      routes: {
        'signup': (context) => const Signup(
              email: '',
            ),
        'login': (context) => const Login(),
        'homescreen': (context) => const Homescreen(),
        'symptomscheck': (context) => const Symptomscheck(),
      },
    );
  }
}
