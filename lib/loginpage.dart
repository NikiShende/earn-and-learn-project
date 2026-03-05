// import 'package:earn_and_learn_project/about_app.dart';
// import 'Coordinator/coordinatordashboard.dart';
// import 'HOD/hoddashboard.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'registerpage.dart';
// import 'studDashboard.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   String selectedRole = "Student";

// Future<void> saveUserSession(String uid, String role) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString("uid", uid);
//   await prefs.setString("role", role);
// }

//   Future<void> loginUser() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_isLoading) return;

//     setState(() => _isLoading = true);

//     try {
//       if (_emailController.text.trim() == "cc@gmail.com" &&
//           _passwordController.text.trim() == "123456" &&
//           selectedRole == "Coordinator") {

//         showSuccessSnackbar("Login Successful 🎉");
// await saveUserSession("main-coordinator", "Coordinator");

// print("SESSION SAVED FOR COORDINATOR ✅");
//         await Future.delayed(const Duration(milliseconds: 600));
// if (!mounted) return;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => CoordinatorDashboard(
             
             
//             ),
//           ),
//         );
//         return;
//       }

//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       final uid = userCredential.user!.uid;

//       DatabaseReference ref;

//       if (selectedRole == "Student") {
//         ref = FirebaseDatabase.instance.ref("users/$uid");
//       } else {
//         ref = FirebaseDatabase.instance.ref("hods/$uid");
//       }

//       DatabaseEvent event = await ref.once();

//       if (!event.snapshot.exists) {
//         throw "User data not found for selected role";
//       }

//       Map userData = event.snapshot.value as Map;

//       showSuccessSnackbar("Login Successful 🎉");
//       await Future.delayed(const Duration(milliseconds: 600));

//       if (selectedRole == "Student") {
//         await saveUserSession(uid, selectedRole);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => Studdashboard(uid: uid)),
//         );
//       } else if (selectedRole == "HOD") {
//         await saveUserSession(uid, selectedRole);


//         Navigator.pushReplacement(
//   context,
//   MaterialPageRoute(
//     builder: (_) => HodDashboard(uid: uid),
//   ),
// );

//       } else {
//        await saveUserSession("main-coordinator", "Coordinator");


//         Navigator.pushReplacement(
//           context,

//           MaterialPageRoute(
//             builder: (_) => CoordinatorDashboard(
            

//             ),
//           ),
//         );
//       }

//     } on FirebaseAuthException catch (e) {
//       showErrorSnackbar(e.message ?? "Login failed");
//     } catch (e) {
//       showErrorSnackbar(e.toString());
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   void showSuccessSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(20),
//         backgroundColor: Colors.green.shade600,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         ),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   void showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(20),
//         backgroundColor: Colors.red.shade600,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         content: Row(
//           children: [
//             const Icon(Icons.error, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   //  const Color(0xFF0B1E3D)

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:const Color(0xFF0B1E3D),
//       body: Stack(
//         children: [

//           /// MAIN UI
//           SingleChildScrollView(
//             child: Column(
//               children: [

//                 /// HEADER
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.only(top: 80, bottom: 40),
//                   child: const Column(
//                     children: [
//                       Icon(Icons.school_rounded,
//                           size: 70, color: Colors.white),
//                       SizedBox(height: 15),
//                       Text(
//                         "Earn & Learn",
//                         style: TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),

//                 /// LOGIN CARD
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(20),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(30)),
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [

//                         TextFormField(
//                           controller: _emailController,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Email is required";
//                             }
//                             return null;
//                           },
//                           decoration: inputDecoration(
//                             label: "Email",
//                             icon: Icons.email_outlined,
//                           ),
//                         ),

//                         const SizedBox(height: 15),

//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: _obscurePassword,
//                           validator: (value) =>
//                               value == null || value.isEmpty
//                                   ? "Password is required"
//                                   : null,
//                           decoration: InputDecoration(
//                             labelText: "Password",
//                             prefixIcon: const Icon(Icons.lock_outline),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscurePassword
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscurePassword =
//                                       !_obscurePassword;
//                                 });
//                               },
//                             ),
//                             filled: true,
//                             fillColor: Colors.grey.shade200,
//                             border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.circular(20),
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 15),

//                         DropdownButtonFormField(
//                           value: selectedRole,
//                           items: ["Student", "HOD", "Coordinator"]
//                               .map((role) => DropdownMenuItem(
//                                     value: role,
//                                     child: Text(role),
//                                   ))
//                               .toList(),
//                           onChanged: (value) =>
//                               setState(() => selectedRole = value!),
//                           decoration: inputDecoration(),
//                         ),

//                         const SizedBox(height: 20),

//                         SizedBox(
//                           width: double.infinity,
//                           height: 55,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   const Color(0xFF1E56A0),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(20),
//                               ),
//                             ),
//                             onPressed:
//                                 _isLoading ? null : loginUser,
//                             child: _isLoading
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white)
//                                 : const Text(
//                                     "LOGIN",
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.white,
//                                         fontWeight:
//                                             FontWeight.bold),
//                                   ),
//                           ),
//                         ),

//                         const SizedBox(height: 15),

//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) =>
//                                       const RegisterScreen()),
//                             );
//                           },
//                           child: RichText(
//   text: TextSpan(
//     style: TextStyle(
//       color: Colors.black, // default color
//       fontSize: 14,
//     ),
//     children: [
//       TextSpan(
//         text: "Don't have an account? ",
//       ),
//       TextSpan(
//         text: "Register",
//         style: TextStyle(
//           color: Colors.deepPurple, // Different color for Register
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ],
//   ),
// ),

//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           /// 🔹 ABOUT ICON (TOP RIGHT)
//           Positioned(
//             top: 50,
//             right: 15,
//             child: IconButton(
//               icon: const Icon(
//                 Icons.info_outline,
//                 color: Colors.white,
//                 size: 26,
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const AboutAppPage(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   InputDecoration inputDecoration(
//       {String? label, IconData? icon}) {
//     return InputDecoration(
//       labelText: label,
//       prefixIcon: icon != null ? Icon(icon) : null,
//       filled: true,
//       fillColor: Colors.grey.shade200,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(20),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }
// }



import 'package:earn_and_learn_project/about_app.dart';
import 'package:earn_and_learn_project/sub-cordinator/sub_cordinatordash.dart';
import 'Coordinator/coordinatordashboard.dart';
import 'HOD/hoddashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'registerpage.dart';
import 'studDashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  String selectedRole = "Student";

Future<void> saveUserSession(String uid, String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("uid", uid);
  await prefs.setString("role", role);
}

Future<void> loginUser() async {
  if (!_formKey.currentState!.validate()) return;
  if (_isLoading) return;

  setState(() => _isLoading = true);

  try {

    /// ✅ MAIN COORDINATOR (Hardcoded Admin)
    if (_emailController.text.trim() == "cc@gmail.com" &&
        _passwordController.text.trim() == "123456" &&
        selectedRole == "Coordinator") {

      await saveUserSession("main-coordinator", "coordinator");

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const CoordinatorDashboard(),
        ),
      );
      return;
    }

    /// 🔐 Firebase Authentication
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    final uid = userCredential.user!.uid;

    /// 🔎 CHECK ROLE FROM DATABASE PATHS
    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref("users/$uid");

    DatabaseReference hodRef =
        FirebaseDatabase.instance.ref("hods/$uid");

    DatabaseReference subRef =
        FirebaseDatabase.instance.ref("sub_coordinators/$uid");

    final usersSnap = await usersRef.get();
    final hodSnap = await hodRef.get();
    final subSnap = await subRef.get();

    String? dbRole;

    if (usersSnap.exists) {
      dbRole = "student";
    } 
    else if (subSnap.exists) {
      dbRole = "sub_coordinator";
    } 
    else if (hodSnap.exists) {
      dbRole = "hod";
    } 
    else {
      throw "Account role not found.";
    }

    /// ✅ Match dropdown role
    String selectedRoleFormatted =
        selectedRole.toLowerCase().replaceAll("-", "_");

    if (selectedRoleFormatted != dbRole) {
      throw "Selected role does not match your account role.";
    }

    /// ✅ Save session
    await saveUserSession(uid, dbRole);

    if (!mounted) return;

    /// 🚀 NAVIGATION BASED ON ROLE
    switch (dbRole) {
      case "student":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Studdashboard(uid: uid),
          ),
        );
        break;

      case "sub_coordinator":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SubCoordinatorDashboard(uid: uid),
          ),
        );
        break;

      case "hod":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HodDashboard(uid: uid),
          ),
        );
        break;

      case "coordinator":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const CoordinatorDashboard(),
          ),
        );
        break;
    }

  } on FirebaseAuthException catch (e) {
    showErrorSnackbar(e.message ?? "Login failed");
  } catch (e) {
    showErrorSnackbar(e.toString());
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}


  void showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        backgroundColor: Colors.green.shade600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        backgroundColor: Colors.red.shade600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //  const Color(0xFF0B1E3D)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFF0B1E3D),
      body: Stack(
        children: [

          /// MAIN UI
          SingleChildScrollView(
            child: Column(
              children: [

                /// HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 80, bottom: 40),
                  child: const Column(
                    children: [
                      Icon(Icons.school_rounded,
                          size: 70, color: Colors.white),
                      SizedBox(height: 15),
                      Text(
                        "Earn & Learn",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),

                /// LOGIN CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            return null;
                          },
                          decoration: inputDecoration(
                            label: "Email",
                            icon: Icons.email_outlined,
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: (value) =>
                              value == null || value.isEmpty
                                  ? "Password is required"
                                  : null,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword =
                                      !_obscurePassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField(
                          value: selectedRole,
                         items: ["Student", "Sub-Coordinator", "HOD", "Coordinator"]

                              .map((role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(role),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => selectedRole = value!),
                          decoration: inputDecoration(),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF1E56A0),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                            ),
                            onPressed:
                                _isLoading ? null : loginUser,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    "LOGIN",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight:
                                            FontWeight.bold),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const RegisterScreen()),
                            );
                          },
                          child: RichText(
  text: TextSpan(
    style: TextStyle(
      color: Colors.black, // default color
      fontSize: 14,
    ),
    children: [
      TextSpan(
        text: "Don't have an account? ",
      ),
      TextSpan(
        text: "Register",
        style: TextStyle(
          color: Colors.deepPurple, // Different color for Register
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),

                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 ABOUT ICON (TOP RIGHT)
       
        ],
      ),
    );
  }

  InputDecoration inputDecoration(
      {String? label, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }
}



