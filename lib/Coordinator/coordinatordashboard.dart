import 'package:earn_and_learn_project/Coordinator/addhod.dart';
import 'package:earn_and_learn_project/Coordinator/exceldata.dart';
import 'package:earn_and_learn_project/student_details_page.dart';
import 'package:earn_and_learn_project/Coordinator/viewhod.dart';
import 'package:earn_and_learn_project/loginpage.dart';
import 'package:earn_and_learn_project/sub-cordinator/sub_cordinatordash.dart';
import 'package:earn_and_learn_project/sub-cordinator/view_sub_cordinator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'coordinatorservice.dart';
import '../utils/auth_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';





class ExportPreviewPage extends StatefulWidget {
  const ExportPreviewPage({super.key});

  @override
  State<ExportPreviewPage> createState() => _ExportPreviewPageState();
}

class _ExportPreviewPageState extends State<ExportPreviewPage> {
  List<Map<String, dynamic>> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }
  

  void _loadStudents() async {
    final ref = FirebaseDatabase.instance.ref('users');
    final snapshot = await ref.get();
    
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final List<Map<String, dynamic>> loadedStudents = [];
      
      data.forEach((uid, userData) {
        final user = Map<String, dynamic>.from(userData);
        double totalHours = 0;
        double approvedHours = 0;
        
        if (user['workEntries'] != null) {
          final workEntries = Map<String, dynamic>.from(user['workEntries']);
          for (final work in workEntries.values) {
            final workData = Map<String, dynamic>.from(work);
            final hours = double.tryParse(workData['hours']?.toString() ?? '0') ?? 0;
            totalHours += hours;
            final status =
    workData['status']?.toString().toLowerCase().trim();

if (status == 'approved_by_sub' ||
    status == 'verified_by_hod') {
  approvedHours += hours;
}

          }
        }
        
      user['totalHours'] = totalHours;
user['approvedHours'] = approvedHours;
user['totalAmount'] = approvedHours * 55;

/// ✅ Only add if approved hours > 0
if (approvedHours > 0) {
  loadedStudents.add(user);
}

      });
      
      setState(() {
        students = loadedStudents;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E3D),
        foregroundColor: Colors.white,
        title: const Text('Export Preview'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.download, color: Colors.white),
            label: const Text('Download Excel', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () async {
  final exporter = UserExcelExporter();
  await exporter.exportUsersToExcel();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Excel downloaded successfully"),
      backgroundColor: Colors.green,
    ),
  );
}
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.table_chart, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Excel Preview - ${students.length} Students',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
                          columns: const [
                            DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Mobile', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Class', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Account Holder', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Account Number', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(
                                   label: Text(
                                  'IFSC Code',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            DataColumn(label: Text('Total Hours', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Approved Hours', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Amount (₹)', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: students.map((student) {
                            return DataRow(
                              color: MaterialStateProperty.all(Colors.white),
                              cells: [
                                DataCell(Text(student['name'] ?? 'N/A')),
                                DataCell(Text(student['email'] ?? 'N/A')),
                                DataCell(Text(student['mobile'] ?? 'N/A')),
                                DataCell(Text(student['class'] ?? 'N/A')),
                                DataCell(Text(student['actualDepartment'] ?? 'N/A')),
                                DataCell(Text(student['accountHolderName'] ?? 'N/A')),
                                DataCell(Text(student['accountNumber'] ?? 'N/A')),
                                DataCell(Text(student['ifscCode'] ?? 'N/A')),
                                DataCell(Text(student['totalHours']?.toStringAsFixed(1) ?? '0')),
                                DataCell(Text(student['approvedHours']?.toStringAsFixed(1) ?? '0')),
                                DataCell(Text(student['totalAmount']?.toStringAsFixed(2) ?? '0')),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class CoordinatorDashboard extends StatefulWidget {
  const CoordinatorDashboard({super.key});

  @override
  State<CoordinatorDashboard> createState() =>
      _CoordinatorDashboardState();
}

class _CoordinatorDashboardState extends State<CoordinatorDashboard>
    with SingleTickerProviderStateMixin {
  String searchText = "";
  String selectedDept = "All";
bool isLoading = true;
bool hasNetworkError = false;
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("users");

  List<Map<String, dynamic>> students = [];
  late TabController _tabController;
  final DashboardService service = DashboardService();

  late final Stream<int> _totalStudentsStream;
  late final Stream<double> _approvedHoursStream;
  late final Stream<double> _monthlyExpenseStream;
  
  final List<String> departments = [
    "All",
    "Computer",
    "IT",
    "ECE",
    "ETC",
    "Mechanical",
    "Civil",
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
  "NSS Office",
  ];

  @override
  void initState() {
    super.initState();
    fetchStudents();
    _tabController = TabController(length: 2, vsync: this);
    _totalStudentsStream = service.totalStudents().asBroadcastStream();
    _approvedHoursStream = service.approvedHours().asBroadcastStream();
    _monthlyExpenseStream = service.monthlyExpense().asBroadcastStream();
  }
  double getTotalApprovedHours() {
  double total = 0;

  for (var student in students) {
    if (student['workEntries'] != null) {
      final workEntries =
          Map<String, dynamic>.from(student['workEntries']);

      for (var work in workEntries.values) {
        final workData = Map<String, dynamic>.from(work);

      final status =
    workData['status']?.toString().toLowerCase().trim();

if (status == 'approved_by_sub' ||
    status == 'verified_by_hod') {
  final hours =
      double.tryParse(workData['hours']?.toString() ?? '0') ?? 0;
  total += hours;
}

      }
    }
  }

  return total;
}

double getMonthlyExpense() {
  return getTotalApprovedHours() * 55;
}


//  void fetchStudents() {

//   dbRef.onValue.listen((event) {
//     final data = event.snapshot.value as Map<dynamic, dynamic>?;

//     if (data != null) {
//       final List<Map<String, dynamic>> tempList = [];

//       data.forEach((uid, userRaw) {
//         final user = Map<String, dynamic>.from(userRaw);

//         if (user['workEntries'] != null) {
//           final workEntries =
//               Map<String, dynamic>.from(user['workEntries']);

//           bool hasApproved = false;

//           workEntries.forEach((_, workRaw) {
//             final work = Map<String, dynamic>.from(workRaw);
//             final status =
//     work['status']?.toString().toLowerCase().trim();

// if (status == 'approved_by_sub' ||
//     status == 'verified_by_hod') {
//   hasApproved = true;
// }

//           });

//           if (hasApproved) {
//             user['id'] = uid;
//             tempList.add(user);
//           }
//         }
//       });

//       setState(() {
//         students = tempList;
//       });
//     }
//   });
// }


void fetchStudents() {
  setState(() {
    isLoading = true;
    hasNetworkError = false;
  });

  dbRef.onValue.listen(
    (event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      final List<Map<String, dynamic>> tempList = [];

      if (data != null) {
        data.forEach((uid, userRaw) {
          final user = Map<String, dynamic>.from(userRaw);

          if (user['workEntries'] != null) {
            final workEntries =
                Map<String, dynamic>.from(user['workEntries']);

            bool hasApproved = false;

            workEntries.forEach((_, workRaw) {
              final work = Map<String, dynamic>.from(workRaw);

              final status =
                  work['status']?.toString().toLowerCase().trim();

              if (status == 'approved_by_sub' ||
                  status == 'verified_by_hod') {
                hasApproved = true;
              }
            });

            if (hasApproved) {
              user['id'] = uid;
              tempList.add(user);
            }
          }
        });
      }

      setState(() {
        students = tempList;
        isLoading = false;
        hasNetworkError = false;
      });
    },

    /// ✅ NETWORK ERROR HANDLING
    onError: (error) {
      setState(() {
        isLoading = false;
        hasNetworkError = true;
      });
    },
  );
}

  void deleteStudent(String id) {
    dbRef.child(id).remove();
  }

  void editStudent(String id, Map<String, dynamic> updatedData) {
    dbRef.child(id).update(updatedData);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Expanded(
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.25),
              child: Icon(icon, color: Colors.white),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget actionCard({
  required String title,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 110,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget studentCard(Map<String, dynamic> s) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudentDetailsPage(
              student: s,
              uid: s['id'],
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s['name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text("Class: ${s['class']}"),
                    Text("Dept: ${s['workingDepartment']}"),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = students.where((s) {
  final nameMatch =
      (s['name'] ?? "").toString().toLowerCase()
          .contains(searchText.toLowerCase());

  final deptMatch = selectedDept == "All" ||
      (s['workingDepartment'] ?? "")
          .toString()
          .trim()
          .toLowerCase() ==
      selectedDept.trim().toLowerCase();

  return nameMatch && deptMatch;
}).toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
     backgroundColor:const Color(0xFF0B1E3D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E3D),
        foregroundColor: Colors.white,
        title: const Text("Coordinator Dashboard",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
        toolbarHeight: 80,

        automaticallyImplyLeading: false,
        actions: [
          IconButton(
  icon: const Icon(Icons.logout),
  onPressed: () {
    AuthUtils.showLogoutDialog(context);
  },
),

        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
           mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
              statCard(
  title: "Total Students",
  value: "${students.length}",
  icon: Icons.people,
  gradient: [Colors.blue, Colors.blueAccent],
),

                const SizedBox(width: 10),
                statCard(
  title: "Approved Hours",
  value: "${getTotalApprovedHours().toStringAsFixed(1)}",
  icon: Icons.timer,
  gradient: [Colors.green, Colors.teal],
),

const SizedBox(width: 10),

statCard(
  title: "Monthly Expense",
  value: "₹${getMonthlyExpense().toStringAsFixed(0)}",
  icon: Icons.currency_rupee,
  gradient: [Colors.orange, Colors.redAccent],
),

              ],
            ),
            const SizedBox(height: 16),
           SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      actionCard(
        title: "HOD's",
        icon: Icons.person_add,
        color: Colors.blue.shade700,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const HodManagementPage(),
            ),
          );
        },
      ),

      const SizedBox(width: 12),

      actionCard(
        title: "Sub-Coordinators",
        icon: Icons.supervisor_account,
        color: Colors.purple.shade700,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ViewSubCoordinatorPage(),
            ),
          );
        },
      ),

      const SizedBox(width: 12),

      actionCard(
        title: "Export Data",
        icon: Icons.download,
        color: Colors.green.shade700,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ExportPreviewPage(),
            ),
          );
        },
      ),
    ],
  ),
),

            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => searchText = value),
              decoration: InputDecoration(
                hintText: "Search student...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: departments.length,
                itemBuilder: (context, index) {
                  final dept = departments[index];
                  final isSelected = dept == selectedDept;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(dept),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => selectedDept = dept);
                      },
                      selectedColor: Colors.blue.shade700,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
           Expanded(
  child: isLoading
      ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text("Loading students...",
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        )

      : hasNetworkError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off,
                      size: 60, color: Colors.white70),
                  const SizedBox(height: 12),
                  const Text(
                    "Network issue.\nPlease check your internet connection.",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: fetchStudents,
                    child: const Text("Retry"),
                  )
                ],
              ),
            )

          : filteredStudents.isEmpty
              ? const Center(
                  child: Text(
                    "No students found",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView(
                  children:
                      filteredStudents.map((s) => studentCard(s)).toList(),
                ),
)
          ],
        ),
      ),
    );
  }
}