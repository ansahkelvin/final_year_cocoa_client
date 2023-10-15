import 'package:cocoa_project/firebase_options.dart';
import 'package:cocoa_project/pages/auth/login.dart';
import 'package:cocoa_project/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocoa Disease Detector Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}

// TODO: LINK THE PROJECT TO FIREBASE 
// BUILD HOME PAGE
// BUILD AUTH AND REGISTER PAGE
// ADD CAMERA PLUGIN TO THE APP
// RESULTS PAGE
// EDIT USER ACCOUNT
