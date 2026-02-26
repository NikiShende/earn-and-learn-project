// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';

// class AddHodPage extends StatefulWidget {
//   const AddHodPage({super.key});

//   @override
//   State<AddHodPage> createState() => _AddHodPageState();
// }

// class _AddHodPageState extends State<AddHodPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _auth = FirebaseAuth.instance;
//   final _dbRef = FirebaseDatabase.instance.ref().child('hods');
// bool _obscurePassword = true;

//   String name = '';
//   String email = '';
//   String password = '';
//   String department = 'Computer';
//   String phone = '';

//   final List<String> departments = [
//     'Computer', 'IT', 'ECE', 'ETC', 'Mechanical', 'Civil', 'AI & DS', "Library","Chemical","A & R",'Instrumentation'
//   "Hostel",
//   "TPC Coordinator",
//   "Gymkhana",'Other'
//   ];

//   bool loading = false;

//   void addHod() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     setState(() => loading = true);

//     try {
//       UserCredential userCred = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       await _dbRef.child(userCred.user!.uid).set({
//         'name': name,
//         'email': email,
//         'department': department,
//         'phone': phone,
//       });

//       setState(() => loading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("HOD added successfully!")),
//       );

//       Navigator.pop(context);
//     } on FirebaseAuthException catch (e) {
//       setState(() => loading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.message ?? "Failed to add HOD")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text("Add HOD"),
//         backgroundColor: Colors.purple.shade700,
//         elevation: 2,
//       ),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16),
//               child: Center(
//                 child: Card(
//                   elevation: 8,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Form(
//                       key: _formKey,
//                       child: ListView(
//                         shrinkWrap: true,
//                         children: [
//                           Text(
//                             "HOD Information",
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.purple.shade700,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           _buildTextField(
//                             label: "Full Name",
//                             icon: Icons.person,
//                             validator: (v) => v!.isEmpty ? "Enter name" : null,
//                             onSaved: (v) => name = v!.trim(),
//                           ),
//                           const SizedBox(height: 12),
//                           _buildTextField(
//                             label: "Email",
//                             icon: Icons.email,
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (v) => v!.isEmpty ? "Enter email" : null,
//                             onSaved: (v) => email = v!.trim(),
//                           ),
//                           const SizedBox(height: 12),
//                           _buildTextField(
//                             label: "Password",
                            
//                             icon: Icons.lock,
//                             obscureText: true,
//                             validator: (v) => v!.length < 6 ? "Password must be 6+ chars" : null,
//                             onSaved: (v) => password = v!.trim(),
//                           ),
//                           const SizedBox(height: 12),
//                           DropdownButtonFormField(
//                             value: department,
//                             items: departments
//                                 .map((d) => DropdownMenuItem(
//                                       value: d,
//                                       child: Text(d),
//                                     ))
//                                 .toList(),
//                             onChanged: (value) => department = value.toString(),
//                             decoration: InputDecoration(
//                               labelText: "Department",
//                               prefixIcon: const Icon(Icons.account_tree),
//                               filled: true,
//                               fillColor: Colors.grey.shade200,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           _buildTextField(
//                             label: "Phone",
//                             icon: Icons.phone,
//                             keyboardType: TextInputType.phone,
//                             validator: (v) => v!.isEmpty ? "Enter phone number" : null,
//                             onSaved: (v) => phone = v!.trim(),
//                           ),
//                           const SizedBox(height: 24),
//                           ElevatedButton(
//                             onPressed: addHod,
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                               backgroundColor: Colors.purple.shade700,
//                               elevation: 4,
//                             ),
//                             child: const Text(
//                               "Add HOD",
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//  Widget _buildTextField({
//   required String label,
//   required IconData icon,
//   bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text, 
//   String? Function(String?)? validator,
//   void Function(String?)? onSaved,
// }) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 16),
//     child: TextFormField(
//       obscureText: obscureText ? _obscurePassword : false,
//       validator: validator,
//       onSaved: onSaved,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         filled: true,
//         fillColor: Colors.grey.shade200,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide.none,
//         ),
//         suffixIcon: obscureText
//             ? IconButton(
//                 icon: Icon(
//                   _obscurePassword
//                       ? Icons.visibility_off
//                       : Icons.visibility,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscurePassword = !_obscurePassword;
//                   });
//                 },
//               )
//             : null,
//       ),
//     ),
//   );
// }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AddHodPage extends StatefulWidget {
  final Map<String, dynamic>? hodData;
  final String? hodId;

  const AddHodPage({super.key, this.hodData, this.hodId});

  @override
  State<AddHodPage> createState() => _AddHodPageState();
}

class _AddHodPageState extends State<AddHodPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.ref().child('hods');

  bool _obscurePassword = true;

  String name = '';
  String email = '';
  String password = '';
  String department = 'Computer';
  String phone = '';

  final List<String> departments = [
    'Computer',
    'IT',
    'ECE',
    'ETC',
    'Mechanical',
    'Civil',
    'AI & DS',
    'Library',
    'Chemical',
    'A & R',
    'Instrumentation',
    'Hostel',
    'TPC Coordinator',
    'Gymkhana',
    "FE-Chemistry",
  "Mathematics",
  "Physics",
  "Earn and Learn",
  "Workshop",
  "Mess",
  "Administrative Office",
  "Exam Section",
  "NSS Office",
  "AICTE IDEA Lab",
    'Other'
  ];

  bool loading = false;

  @override
  void initState() {
    super.initState();

    /// 🔹 If Edit Mode
    if (widget.hodData != null) {
      name = widget.hodData!['name'] ?? '';
      email = widget.hodData!['email'] ?? '';
      department = widget.hodData!['department'] ?? 'Computer';
      phone = widget.hodData!['phone'] ?? '';
    }
  }

  void addOrUpdateHod() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => loading = true);

    try {
      if (widget.hodId != null) {
        /// 🔹 UPDATE MODE
        await _dbRef.child(widget.hodId!).update({
          'name': name,
          'department': department,
          'phone': phone,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("HOD updated successfully!"),
          backgroundColor: Colors.green,),
        );
      } else {
        /// 🔹 ADD MODE
        UserCredential userCred =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await _dbRef.child(userCred.user!.uid).set({
          'name': name,
          'email': email,
          'department': department,
          'phone': phone,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("HOD added successfully!"),
          backgroundColor: Colors.green,
          ),
        );
      }

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Operation failed"),
        backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),
       
      appBar: AppBar(
        title: Text(widget.hodId != null ? "Edit HOD" : "Add HOD"),
        foregroundColor: Colors.white,
         titleTextStyle: const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
        backgroundColor: const Color(0xFF0B1E3D),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Text(
                            widget.hodId != null
                                ? "Edit HOD Information"
                                : "HOD Information",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E56A0),
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// NAME
                          _buildTextField(
                            label: "Full Name",
                            icon: Icons.person,
                            initialValue: name,
                            validator: (v) =>
                                v!.isEmpty ? "Enter name" : null,
                            onSaved: (v) => name = v!.trim(),
                          ),

                          /// EMAIL (Disable in edit mode)
                          _buildTextField(
                            label: "Email",
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            initialValue: email,
                            enabled: widget.hodId == null,
                            validator: (v) =>
                                v!.isEmpty ? "Enter email" : null,
                            onSaved: (v) => email = v!.trim(),
                          ),

                          /// PASSWORD (Only in Add Mode)
                          if (widget.hodId == null)
                            _buildTextField(
                              label: "Password",
                              icon: Icons.lock,
                              obscureText: true,
                              validator: (v) => v!.length < 6
                                  ? "Password must be 6+ chars"
                                  : null,
                              onSaved: (v) => password = v!.trim(),
                            ),

                          const SizedBox(height: 12),

                          /// DEPARTMENT
                          DropdownButtonFormField(
                            value: department,
                            items: departments
                                .map((d) => DropdownMenuItem(
                                      value: d,
                                      child: Text(d),
                                    ))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => department = value.toString()),
                            decoration: InputDecoration(
                              labelText: "Department",
                              prefixIcon: const Icon(Icons.account_tree),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// PHONE
                          _buildTextField(
                            label: "Phone",
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            initialValue: phone,
                            validator: (v) =>
                                v!.isEmpty ? "Enter phone number" : null,
                            onSaved: (v) => phone = v!.trim(),
                          ),

                          const SizedBox(height: 24),

                          ElevatedButton(
                            onPressed: addOrUpdateHod,
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor:
                                  const Color(0xFF1E56A0),
                            ),
                            child: Text(
                              widget.hodId != null
                                  ? "Update HOD"
                                  : "Add HOD",
                              style: const TextStyle(
                                  fontSize: 16,color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    String? initialValue,
    bool obscureText = false,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obscureText ? _obscurePassword : false,
        enabled: enabled,
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          suffixIcon: obscureText
              ? IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
