import 'package:easy_first_aid/constants/apiKey.dart';
import 'package:easy_first_aid/firebase_options.dart';
import 'package:easy_first_aid/screens/ai_assistant.dart';
import 'package:easy_first_aid/screens/homescreen.dart';
import 'package:easy_first_aid/auth/login.dart';
import 'package:easy_first_aid/auth/signup.dart';
import 'package:easy_first_aid/screens/startScreen.dart';
import 'package:easy_first_aid/screens/symptomscheck.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:showcaseview/showcaseview.dart';
// import 'package:swipeable_button_view/swipeable_button_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(apiKey: Gemini_ApiKey);
  runApp(
    ShowCaseWidget(builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Startscreen(),
      routes: {
        'signup': (context) => const Signup(
              email: '',
            ),
        'login': (context) => const Login(),
        'homescreen': (context) => const Homescreen(),
        'symptomscheck': (context) => const Symptomscheck(),
        'ai_Assistant': (context) => const GeminiApp(),
      },
    );
  }
}
