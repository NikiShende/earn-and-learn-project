import 'dart:async';
import 'package:earn_and_learn_project/sub-cordinator/sub_cordinatordash.dart';

import 'Coordinator/coordinatordashboard.dart';
import 'registerpage.dart';
import 'studDashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HOD/hoddashboard.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // 🔥 REQUIRED
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen()
    );
  }
}class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
     _checkLogin();

    // Delay for 3 seconds
   

    // Show loading for 2 seconds, then hide it
   
  }
  Future<void> _checkLogin() async {
  final prefs = await SharedPreferences.getInstance();
  String? uid = prefs.getString("uid");
  String? role = prefs.getString("role");

  print("SESSION FOUND → UID: $uid ROLE: $role");

  await Future.delayed(const Duration(seconds: 2));

  if (!mounted) return;

  if (uid != null && role != null) {

    role = role.toLowerCase(); // 🔥 important

    if (role == "student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Studdashboard(uid: uid)),
      );
    }

    else if (role == "sub_coordinator") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SubCoordinatorDashboard(uid: uid),
        ),
      );
    }

    else if (role == "hod") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HodDashboard(uid: uid),
        ),
      );
    }

    else if (role == "coordinator") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const CoordinatorDashboard(),
        ),
      );
    }

    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }

  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          if (_isLoading)
            const Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}