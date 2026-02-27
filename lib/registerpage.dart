// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class RegisterScreen extends StatefulWidget {
  
//   const RegisterScreen({super.key});
  

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
// final TextEditingController nameCtrl = TextEditingController();
// final TextEditingController emailCtrl = TextEditingController();
// final TextEditingController passCtrl = TextEditingController();
// final TextEditingController mobileCtrl = TextEditingController();
// final TextEditingController workplaceCtrl = TextEditingController();
// final TextEditingController accNameCtrl = TextEditingController();
// final TextEditingController accNoCtrl = TextEditingController();
// final TextEditingController classCtrl = TextEditingController();
// final TextEditingController yearCtrl = TextEditingController();
// bool _isLoading = false;

// Future<void> registerUser() async {
//   if (_isLoading) return;
  
//   // Validate all required fields
//   if (nameCtrl.text.trim().isEmpty ||
//       emailCtrl.text.trim().isEmpty ||
//       passCtrl.text.trim().isEmpty ||
//       mobileCtrl.text.trim().isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Please fill all required fields")),
//     );
//     return;
//   }

//   // Additional validation for student fields
//   if (selectedRole == "Student" &&
//       (classCtrl.text.trim().isEmpty ||
//        accNameCtrl.text.trim().isEmpty ||
//        accNoCtrl.text.trim().isEmpty)) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Please fill all student fields")),
//     );
//     return;
//   }
  
//   setState(() {
//     _isLoading = true;
//   });

//   try {
//     // 1️⃣ Create Auth User
//     UserCredential userCredential =
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: emailCtrl.text.trim(),
//       password: passCtrl.text.trim(),
//     );

//     String uid = userCredential.user!.uid;
//     final user = FirebaseAuth.instance.currentUser;

//     // 2️⃣ Save to Realtime Database
//     DatabaseReference ref =
//         FirebaseDatabase.instance.ref("users/$uid");

//     Map<String, dynamic> userData = {
//       "name": nameCtrl.text.trim(),
//       "email": emailCtrl.text.trim(),
//       "mobile": mobileCtrl.text.trim(),
//       "role": selectedRole,
//       "department": selectedDepartment,
//       "createdAt": DateTime.now().toIso8601String(),
//     };

//     if (selectedRole == "Student") {
//       userData.addAll({
//         "accountHolderName": accNameCtrl.text.trim(),
//         "accountNumber": accNoCtrl.text.trim(),
//         "class": classCtrl.text.trim(),
//         "rollNo": accNoCtrl.text.trim(), // Using account number as roll number for now
//       });
//     }

//     await ref.set(userData);

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Registration Successful ✅")),
//       );
//       Navigator.pop(context);
//     }
//   } catch (e) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   } finally {
//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }

//   /// 🎓 Department List
//   List<String> departments = [
//     "Computer",
//     "Mechanical",
//     "Civil",
//     "ETC",
//     "ECE",
//     "IT",
//     "Chemical",
//     "AI & DS",
//     "A & R",
//     "Instrumentaion"
//   ];

//   String selectedDepartment = "Computer";
//   String selectedRole = "Student";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0E121F),
//       appBar: AppBar(
//         backgroundColor:const Color(0xFF0E121F),
//         foregroundColor: Colors.white,
//         toolbarHeight: 70,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text("Register"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               /// 🔽 Role Dropdown
//               const Text("Select Role",
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 6),
//               DropdownButtonFormField(
//                 value: selectedRole,
//                 items: ["Student"]
//                     .map((role) => DropdownMenuItem(
//                           value: role,
//                           child: Text(role),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() => selectedRole = value!);
//                 },
//                 decoration: inputDecoration(),
//               ),

//               const SizedBox(height: 12),

//            buildField("Name", controller: nameCtrl),
//              buildField("Email", controller: emailCtrl),
//             buildField("Password", isPassword: true, controller: passCtrl),
//             buildField("Mobile No", controller: mobileCtrl, isNumber: true),

//               const SizedBox(height: 10),

//               if (selectedRole == "Student") studentFields(),
//               if (selectedRole == "HOD") hodFields(),

//               const SizedBox(height: 25),

//               /// 🔵 Register Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue.shade900,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                   onPressed: _isLoading ? null : registerUser,
//                   child: _isLoading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                       : const Text("REGISTER",
//                           style: TextStyle(fontSize: 16, color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// 🧱 Text Field Widget
// Widget buildField(String label,
//     {bool isPassword = false, bool isNumber = false, TextEditingController? controller}) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 12),
//     child: TextField(
//       controller: controller,
//       obscureText: isPassword,
//       keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//       inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
//       decoration: inputDecoration(label: label),
//     ),
//   );
// }


//   /// 🎨 Decoration
//   InputDecoration inputDecoration({String? label}) {
//     return InputDecoration(
//       labelText: label,
//       filled: true,
//       fillColor: Colors.grey.shade100,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }

//   /// 🎓 Student Fields
//   Widget studentFields() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         departmentDropdown(),
//         const SizedBox(height: 10),
//        buildField("Class", controller: classCtrl),
   
     
// buildField("Account Holder Name", controller: accNameCtrl),
// buildField("Account Number", controller: accNoCtrl, isNumber: true),

//       ],
//     );
//   }

//   /// 👨‍🏫 HOD Fields
//   Widget hodFields() {
//     return departmentDropdown();
//   }

//   /// 🔽 Shared Department Dropdown
//   Widget departmentDropdown() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Department",
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 6),
//         DropdownButtonFormField(
//           value: selectedDepartment,
//           items: departments
//               .map((dept) => DropdownMenuItem(
//                     value: dept,
//                     child: Text(dept),
//                   ))
//               .toList(),
//           onChanged: (value) {
//             setState(() => selectedDepartment = value!);
//           },
//           decoration: inputDecoration(),
//         ),
//       ],
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController accNameCtrl = TextEditingController();
  final TextEditingController accNoCtrl = TextEditingController();
  final TextEditingController classCtrl = TextEditingController();
  final TextEditingController ifscCtrl = TextEditingController(); // ✅ NEW


  bool _isLoading = false;
  bool _obscurePassword = true; // 👁 toggle
 // 🔐 strength

  String selectedDepartment = "Computer";
  String selectedRole = "Student";
String selectedActualDepartment = "Computer";

  List<String> departments = [
    "Computer",
    "Mechanical",
    "Civil",
    "ETC",
    "ECE",
    "IT",
    "Chemical",
    "AI & DS",
    "A & R",
    "Instrumentation",
    "Library",
    "Hostel",
    "TPC Coordinator",
    "Gymkhana",
  "FE-Chemistry",
  "Mathematics",
  "Physics",
  "Earn and Learn",
  "Workshop",
  "Mess",
  "Administrative Office",
  "Exam Section",
  "NSS",
  "AICTE IDEA Lab",


  ];

List<String> actualDepartments = [
  "Computer",
  "IT",
  "ECE",
  "ETC",
  "Mechanical",
  "Instrumentation",
  "A & R",
  "Civil",
  "AI & DS",
  "Chemical",
  
];
  
  Future<void> registerUser() async {
    if (_isLoading) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      String uid = userCredential.user!.uid;

      DatabaseReference ref =
          FirebaseDatabase.instance.ref("users/$uid");

      await ref.set({
        "name": nameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "mobile": mobileCtrl.text.trim(),
        "role": selectedRole,
        "workingDepartment": selectedDepartment.trim(),
       "actualDepartment": selectedActualDepartment.trim(),

        "createdAt": DateTime.now().toIso8601String(),
        "accountHolderName": accNameCtrl.text.trim(),
        "ifscCode": ifscCtrl.text.trim().toUpperCase(),

        "accountNumber": accNoCtrl.text.trim(),
        "class": classCtrl.text.trim(),
        
        
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(20),
            backgroundColor: Colors.green.shade600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Registration Successful 🎉",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 800));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80, bottom: 40),
              child: const Column(
                children: [
                  Icon(Icons.app_registration_rounded,
                      size: 70, color: Colors.white),
                  SizedBox(height: 15),
                  Text(
                    "Create Account",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),

            /// FORM CARD
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
                    Padding(
  padding: const EdgeInsets.only(bottom: 12),
  child: DropdownButtonFormField(
    value: selectedRole,
    items: ["Student"]
        .map((role) => DropdownMenuItem(
              value: role,
              child: Text(role),
            ))
        .toList(),
    onChanged: (value) =>
        setState(() => selectedRole = value!),
    validator: (value) =>
        value == null ? "Role is required" : null,
    decoration: InputDecoration(
      labelText: "Select Role",
      
      filled: true,
      
      fillColor: Colors.grey.shade200,
      floatingLabelBehavior: FloatingLabelBehavior.always,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
  ),
),


                    buildField("Name", controller: nameCtrl),

                    buildField(
                      "Email",
                      controller: emailCtrl,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                            .hasMatch(value)) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                    ),

                    /// 🔐 PASSWORD WITH EYE TOGGLE
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextFormField(
                        controller: passCtrl,
                        obscureText: _obscurePassword,
                       
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6) {
                            return "Minimum 6 characters required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Password",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
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
                        ),
                      ),
                    ),

                    /// 🔐 PASSWORD STRENGTH BAR
                    if (passCtrl.text.isNotEmpty)



                    const SizedBox(height: 12),

                    buildField(
                      "Mobile No",
                      controller: mobileCtrl,
                      isNumber: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Mobile number is required";
                        }
                        if (value.length != 10) {
                          return "Enter 10 digit number";
                        }
                        return null;
                      },
                    ),

                    departmentDropdown(),
                    actualDepartmentDropdown(),

                    buildField("Class", controller: classCtrl),

                    buildField(
                      "Account Holder Name",
                      controller: accNameCtrl,
                    ),
                    buildField(
                      
                      "IFSC Code",
                      controller: ifscCtrl,
                      
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "IFSC Code is required";
                        }

                        String ifsc = value.trim().toUpperCase();

                        // Remove spaces automatically
                        ifsc = ifsc.replaceAll(" ", "");

                        if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifsc)) {
                          return "Enter valid IFSC (Ex: HDFC0001234)";
                        }

                        return null;
                      },
                    ),


                    buildField(
                      "Account Number",
                      controller: accNoCtrl,
                      isNumber: true,
                    ),

                    const SizedBox(height: 25),


                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF1E56A0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            _isLoading ? null : registerUser,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "REGISTER",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white),
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
    );
  }

  Widget buildField(
    String label, {
    bool isPassword = false,
    bool isNumber = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType:
            isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters:
            isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return "$label is required";
              }
              return null;
            },
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

Widget actualDepartmentDropdown() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField(
      value: selectedActualDepartment,
      items: actualDepartments
          .map((dept) => DropdownMenuItem(
                value: dept,
                child: Text(dept),
              ))
          .toList(),
      onChanged: (value) =>
          setState(() => selectedActualDepartment = value!),
      validator: (value) =>
          value == null ? "Actual Department is required" : null,
      decoration: InputDecoration(
        labelText: "Academic Department",
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
  Widget departmentDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField(
        value: selectedDepartment,
        items: departments
            .map((dept) => DropdownMenuItem(
                  value: dept,
                  child: Text(dept),
                ))
            .toList(),
        onChanged: (value) =>
            setState(() => selectedDepartment = value!),
        validator: (value) =>
            value == null ? "Department is required" : null,
        decoration: InputDecoration(
          labelText: "Working Department",
          filled: true,
           floatingLabelBehavior: FloatingLabelBehavior.always,

          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

