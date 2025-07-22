import 'package:annotatiev02/pages/user/Dashboard.dart';
import 'package:annotatiev02/firebase_options.dart';
import 'package:annotatiev02/pages/annotator/adminHome.dart';
import 'package:annotatiev02/pages/login.dart';
import 'package:annotatiev02/pages/register.dart';
import 'package:annotatiev02/pages/user/add_text_project.dart';
import 'package:annotatiev02/pages/user/add_image_project.dart';
import 'package:annotatiev02/theme/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: 'https://ifwkzwfbpqhqnsuhjrer.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlmd2t6d2ZicHFocW5zdWhqcmVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2MzYwMzQsImV4cCI6MjA2NTIxMjAzNH0.jRWLtX7Y9we0FcMswQFisM_tg9c43IVcPs2D8EjrRAo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: Login(),
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/annotatorHome': (context) => AnnotatorHome(),
        '/userHome': (context) => Dashboard(),
        '/addProject': (context) => AddImageProject(),
        '/addTextProject': (context) => AddTextProject(),
      },
    );
  }
}
