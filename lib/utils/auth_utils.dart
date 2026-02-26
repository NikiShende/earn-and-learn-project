import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  static Future<void> saveUserSession(String uid, String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('uid', uid);
  await prefs.setString('role', role);
  print("SESSION SAVED → UID: $uid ROLE: $role");
}

  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }
  }

  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                logout(context);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}