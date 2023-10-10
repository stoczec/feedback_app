// ignore_for_file: prefer_const_constructors

import 'package:feedback_app/firebase_options.dart';
import 'package:feedback_app/src/authentication/auth.dart';
// ignore: unused_import
import 'package:feedback_app/src/authentication/login_or_register.dart';
// ignore: unused_import
import 'package:feedback_app/src/pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
