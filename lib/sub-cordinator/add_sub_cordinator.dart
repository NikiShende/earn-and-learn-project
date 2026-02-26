import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AddSubCoordinatorPage extends StatefulWidget {
  final Map<String, dynamic>? subData;
  final String? subId;

  const AddSubCoordinatorPage({super.key, this.subData, this.subId});

  @override
  State<AddSubCoordinatorPage> createState() =>
      _AddSubCoordinatorPageState();
}

class _AddSubCoordinatorPageState extends State<AddSubCoordinatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _dbRef =
      FirebaseDatabase.instance.ref().child('sub_coordinators');

  bool _obscurePassword = true;
  bool loading = false;

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

  @override
  void initState() {
    super.initState();

    /// ✅ Edit Mode
    if (widget.subData != null) {
      name = widget.subData!['name'] ?? '';
      email = widget.subData!['email'] ?? '';
      department = widget.subData!['department'] ?? 'Computer';
      phone = widget.subData!['phone'] ?? '';
    }
  }

  /// ✅ ADD / UPDATE SUB COORDINATOR
  void addOrUpdateSubCoordinator() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => loading = true);

    try {
      if (widget.subId != null) {
        /// 🔹 UPDATE MODE
        await _dbRef.child(widget.subId!).update({
          'name': name,
          'department': department,
          'phone': phone,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sub-Coordinator Updated succesfully.."),
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
          'role': 'sub_coordinator',
          'createdAt': DateTime.now().toString(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sub-Coordinator Added succesfully.."),
          ),
        );
      }

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Operation Failed"),
        backgroundColor: Colors.red ,),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),
      appBar: AppBar(
        title: Text(widget.subId != null
            ? "Edit Sub-Coordinator"
            : "Add Sub-Coordinator"),
        backgroundColor: const Color(0xFF0B1E3D),
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Text(
                            widget.subId != null
                                ? "Edit Sub-Coordinator"
                                : "Sub-Coordinator Information",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E56A0),
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

                          /// EMAIL
                          _buildTextField(
                            label: "Email",
                            icon: Icons.email,
                            initialValue: email,
                            enabled: widget.subId == null,
                            validator: (v) =>
                                v!.isEmpty ? "Enter email" : null,
                            onSaved: (v) => email = v!.trim(),
                          ),

                          /// PASSWORD (ADD MODE ONLY)
                          if (widget.subId == null)
                            _buildTextField(
                              label: "Password",
                              icon: Icons.lock,
                              obscureText: true,
                              validator: (v) => v!.length < 6
                                  ? "Min 6 characters"
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
                            onChanged: (v) =>
                                setState(() => department = v.toString()),
                            decoration: InputDecoration(
                              labelText: "Department",
                              prefixIcon:
                                  const Icon(Icons.account_tree),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
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
                                v!.isEmpty ? "Enter phone" : null,
                            onSaved: (v) => phone = v!.trim(),
                          ),

                          const SizedBox(height: 24),

                          ElevatedButton(
                            onPressed: addOrUpdateSubCoordinator,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF1E56A0),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14)),
                            ),
                            child: Text(
                              widget.subId != null
                                  ? "Update Sub-Coordinator"
                                  : "Add Sub-Coordinator",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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

  /// ✅ COMMON TEXTFIELD
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
        enabled: enabled,
        obscureText: obscureText ? _obscurePassword : false,
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
