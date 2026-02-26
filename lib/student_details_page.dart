import 'Coordinator/generatebill.dart';
import 'package:flutter/material.dart';

class StudentDetailsPage extends StatelessWidget {
  final Map<String, dynamic> student;
 final String uid; // 👈 ADD THIS

  const StudentDetailsPage({super.key, required this.student,required this.uid,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xFF0B1E3D),
       
      appBar: AppBar(
        title: const Text("Student Details"),
        backgroundColor: const Color(0xFF0B1E3D),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, size: 50, color: Colors.blue),
              ),
            ),

            const SizedBox(height: 20),

            /// DETAILS CARD
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailRow("Name", student['name'] ?? 'N/A'),
                    detailRow("Class", student['class'] ?? 'N/A'),
                    detailRow("Department", student['workingDepartment'] ?? 'N/A'),
                    detailRow("Email", student['email'] ?? 'N/A'),
                    detailRow("Phone", student['mobile'] ?? 'N/A'),
                    detailRow("accountHolderName", student['accountHolderName'] ?? 'N/A'),
                    detailRow(
                      "accountNumber",
                      student['accountNumber'] ?? 'N/A',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30,),
Row(
  children: [
    Expanded(
      child: 
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MonthlyBillPage(uid: uid),
      ),
    );
  },
  icon: const Icon(Icons.receipt_long),
  label: const Text("Generate Bill"),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green.shade700,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  ),
),

    ),
  ],
),
   ],
        ),
      ),
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey.shade800)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Student"),
        content: const Text("Are you sure you want to delete this student?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Firebase delete logic here
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
