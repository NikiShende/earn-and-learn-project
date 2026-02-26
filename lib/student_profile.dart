import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class StudentProfilePage extends StatefulWidget {
  final String uid;
  const StudentProfilePage({super.key, required this.uid});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {

  final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController classController = TextEditingController();
final TextEditingController accNameCtrl = TextEditingController();
final TextEditingController accNoCtrl = TextEditingController();

  bool isLoading = true;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final snapshot = await _ref.child("users/${widget.uid}").get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      nameController.text = data['name'] ?? "";
      emailController.text = data['email'] ?? "";
      phoneController.text = data['mobile'] ?? "";
     final actualDept = data['actualDepartment'] ?? "";
final workingDept = data['workingDepartment'] ?? "";

courseController.text =
    "$actualDept (${workingDept.isNotEmpty ? workingDept : 'No Work Dept'})";
      classController.text = data['class'] ?? "";
      accNameCtrl.text = data['accountHolderName'] ?? "";
      accNoCtrl.text = data['accountNumber'] ?? "";
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _updateProfile() async {
    setState(() => isLoading = true);

    await _ref.child("users/${widget.uid}").update({
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "course": courseController.text.trim(),
      "class": classController.text.trim(),
      "accountHolderName": accNameCtrl.text.trim(),
      "accountNumber": accNoCtrl.text.trim(),
    });

    setState(() {
      isEditing = false;
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully")),
    );
  }

  Widget _buildTextField(
      {required String label,
      required TextEditingController controller,
      IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 12),
      child: TextField(
        style:TextStyle(
          color: Colors.white,   // 👈 change this
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),
        controller: controller,
       enabled: label != "Course" && isEditing,

        decoration: InputDecoration(
          labelText: label,
          
        prefixIcon: icon != null
    ? Icon(
        icon,
        color: const Color.fromARGB(255, 169, 168, 168),   // 👈 ADD COLOR
      )
    : null,

          filled: true,
          labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 22
        ),
          fillColor: const Color.fromARGB(255, 0, 0, 0),
          border: OutlineInputBorder(
            
           
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),

      appBar: AppBar(
        title: const Text("Student Profile"),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF0B1E3D),
        
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _updateProfile();
              } else {
                setState(() => isEditing = true);
              }
            },
          )
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  /// Profile Card
                 
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Color.fromARGB(255, 36, 72, 101),
                      child: Icon(Icons.person,
                          size: 50, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    const SizedBox(height: 15),
                  

                  const SizedBox(height: 30),

                  /// Editable Fields
                  _buildTextField(
                      label: "Full Name",
                      controller: nameController,
                      icon: Icons.person),

                  _buildTextField(
                      label: "Email",
                      controller: emailController,
                      icon: Icons.email),

                  _buildTextField(
                      label: "Phone",
                      controller: phoneController,
                      icon: Icons.phone),

                  _buildTextField(
                      label: "Course",
                      
                      controller: courseController,
                      icon: Icons.school),

                  _buildTextField(
                      label: "class",
                      controller: classController,
                      icon: Icons.class_),
                       _buildTextField(
                      label: "accountHolderName",
                      controller: accNameCtrl,
                      icon: Icons.account_balance),
                       _buildTextField(
                      label: "accNumber",
                      controller: accNoCtrl,
                      icon: Icons.numbers),
                      

                  if (isEditing)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          backgroundColor: const Color.fromARGB(255, 54, 174, 225),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _updateProfile,
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(fontSize: 16,color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}