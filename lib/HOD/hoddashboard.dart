// import 'dart:async';
// import 'studworkdetails.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:earn_and_learn_project/loginpage.dart';
// import '../utils/auth_utils.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HodDashboard extends StatefulWidget {
//   final Map hodData;
//   final String uid;

//   const HodDashboard({super.key, required this.hodData, required this.uid});

//   @override
//   State<HodDashboard> createState() => _HodDashboardState();
// }

// class _HodDashboardState extends State<HodDashboard>
//     with SingleTickerProviderStateMixin {
//   final DatabaseReference _usersRef = FirebaseDatabase.instance.ref("users");
//   StreamSubscription? _subscription;
// void _updateWorkStatus(String uid, String title, String status) {
//   final userRef = _usersRef.child(uid).child("workEntries");
//   userRef.once().then((snapshot) {
//     final works = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
//     works.forEach((key, workRaw) {
//       final work = Map<String, dynamic>.from(workRaw);
//       if (work["title"] == title) {
//         userRef.child(key).update({"status": status});
//       }
//     });
//   });
// }

//   List<Map<String, dynamic>> allEntries = [];
//   List<Map<String, dynamic>> uniqueStudents = [];
//   bool isLoading = true;
//   String searchQuery = "";

//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _listenToHodEntries(
      
//     );
//   }

//   void _listenToHodEntries() {
//     final hodDept =
//     (widget.hodData["department"] ?? "")
//         .toString()
//         .trim()
//         .toLowerCase();


//     _subscription = _usersRef.onValue.listen((event) {
//       final List<Map<String, dynamic>> entriesList = [];
//       final Map<String, Map<String, dynamic>> studentsMap = {};

//       if (event.snapshot.value != null) {
//         final users = Map<String, dynamic>.from(event.snapshot.value as Map);
//         users.forEach((uid, userRaw) {
//           final user = Map<String, dynamic>.from(userRaw);
//           final dept =
//     (user["department"] ?? "")
//         .toString()
//         .trim()
//         .toLowerCase();

//          if (dept.trim().toLowerCase() != hodDept.trim().toLowerCase()) return;

// print("HOD Department: $hodDept");
// print("Student Department: $dept");

//           // Calculate total work hours for the student
//           double totalHours = 0;
//           if (user["workEntries"] != null) {
//             final workEntries = Map<String, dynamic>.from(user["workEntries"]);
//             workEntries.forEach((_, workRaw) {
//               final work = Map<String, dynamic>.from(workRaw);
//               totalHours += double.tryParse(work["hours"]?.toString() ?? "0") ?? 0;
//               entriesList.add({
//                 "uid": uid,
                
//                 "name": user["name"],
//                 "email": user["email"],
//                 "mobile": user["mobile"] ?? "-",
//                 "department": user["department"],
//                 "title": work["title"],
//                 "hours": work["hours"] ?? 0,
//                 "fromTime": work["fromTime"],
//                 "toTime": work["toTime"],
//                 "workplace": work["workplace"],
//                 "date": work["date"],
//                 "status": work["status"],
//               });
//             });
//           }

//           // Store unique student with total work hours
//           studentsMap[uid] = {
//             "uid": uid,
//             "name": user["name"],
//             "email": user["email"],
//             "mobile": user["mobile"] ?? "-",
//             "totalHours": totalHours,
//           };
//         });
//       }

//       setState(() {
//         allEntries = entriesList;
//         uniqueStudents = studentsMap.values.toList();
//         isLoading = false;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pendingEntries = allEntries
//         .where((e) =>
//             e["status"]?.toString().toLowerCase() == "pending" &&
//             (e["name"] ?? "")
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchQuery.toLowerCase()))
//         .toList();

//     final totalStudents = uniqueStudents.length;
//     final pendingCount = pendingEntries.length;

//     return Scaffold(
//       backgroundColor: const Color(0xFF0B1E3D),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0B1E3D),
//         foregroundColor: Colors.white,
//         title: Text("HOD's Dashboard",style: TextStyle(fontWeight: FontWeight.bold),),
//         automaticallyImplyLeading: false,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // HOD Profile Card
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                       colors: [Color(0xFF1B3A68), Color(0xFF0B1E3D)]),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: const [
//                     BoxShadow(
//                         color: Colors.black45,
//                         blurRadius: 10,
//                         offset: Offset(0, 4))
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.white24,
//                       child: Text(
//                         widget.hodData["name"]?.toString().substring(0, 1) ??
//                             "H",
//                         style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.hodData["name"] ?? "HOD Name",
//                             style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             widget.hodData["email"] ?? "hod@email.com",
//                             style: const TextStyle(
//                                 color: Colors.white70, fontSize: 14),
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             widget.hodData["department"] ?? "Department",
//                             style: const TextStyle(
//                                 color: Colors.white70, fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//   icon: const Icon(Icons.logout),
//   onPressed: () {
//     AuthUtils.showLogoutDialog(context);
//   },
// ),

//                   ],
//                 ),
//               ),
//             ),

//             // const SizedBox(height: 5),

//             // Stats Cards
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: [
//                   _dashboardCard(
//                       "Total Students", "$totalStudents", Colors.blue, Icons.people),
//                   const SizedBox(width: 12),
//                   _dashboardCard("Pending Approvals", "$pendingCount",
//                       Colors.orange, Icons.pending_actions),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 17),

//             // Search
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: TextField(
//                 onChanged: (v) => setState(() => searchQuery = v),
//                 style: const TextStyle(color: Colors.black87),
//                 decoration: InputDecoration(
//                   hintText: "Search student...",
//                   prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide.none),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 15),

//             // Tabs
//             TabBar(
//               controller: _tabController,
//               indicator: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(5)),
//               labelColor: Colors.black87,
//               unselectedLabelColor: Colors.white70,
//               tabs: const [
//                 Tab(text: "  New Requests  "),
//                 Tab(text: "  All students  "),
//               ],
//             ),

//             // Tab Views
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   // New Requests
// // Replace this part inside TabBarView -> New Requests
// isLoading
//     ? const Center(child: CircularProgressIndicator())
//     : pendingEntries.isEmpty
//         ? const Center(
//             child: Text(
//               "No new requests",
//               style: TextStyle(color: Colors.white70),
//             ),
//           )
//         : ListView.builder(
//             itemCount: pendingEntries.length,
//             itemBuilder: (context, index) {
//               final e = pendingEntries[index];
//               return WorkRequestCard(
//                 workData: e,
//                 onApprove: () {
//                   _updateWorkStatus(e["uid"], e["title"], "approved");
//                 },
//                 onReject: () {
//                   _updateWorkStatus(e["uid"], e["title"], "rejected");
//                 },
//               );
//             },
//           ),


//                   // All Students
//                   isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : uniqueStudents.isEmpty
//                           ? const Center(
//                               child: Text(
//                                 "No students found",
//                                 style: TextStyle(color: Colors.white70),
//                               ),
//                             )
//                           : ListView.builder(
//                               itemCount: uniqueStudents.length,
//                               itemBuilder: (context, index) {
//                                 final e = uniqueStudents[index];
//                                 if (!(e["name"] ?? "")
//                                     .toString()
//                                     .toLowerCase()
//                                     .contains(searchQuery.toLowerCase())) {
//                                   return const SizedBox.shrink();
//                                 }
//                                 return StudentCard(
//                                   data: e,
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (_) => StudentDetailPage(
//                                                 studentUid: e["uid"],
//                                                 studentName: e["name"])));
//                                   },
//                                 );
//                               },
//                             ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _dashboardCard(
//       String title, String value, Color color, IconData icon) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//               colors: [color.withOpacity(0.6), color.withOpacity(0.3)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//                 color: color.withOpacity(0.4),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4)),
//           ],
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: color, size: 30),
//                 const SizedBox(width: 10),
//                 Text(value,
//                     style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: color)),
//               ],
//             ),
//             const SizedBox(height: 6),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 title,
//                 style: const TextStyle(color: Colors.white70),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class WorkRequestCard extends StatelessWidget {
//   final Map<String, dynamic> workData;
//   final VoidCallback? onApprove;
//   final VoidCallback? onReject;

//   const WorkRequestCard({
//     super.key,
//     required this.workData,
//     this.onApprove,
//     this.onReject,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final hours = workData["hours"] ?? 0;
//     final date = workData["date"] ?? "-";

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Work Title
//           Text(
//             workData["title"] ?? "Work Title",
//             style: const TextStyle(
//                 fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
//           ),
//           const SizedBox(height: 6),

//           // Student Name
//           Row(
//             children: [
//               const Icon(Icons.person, size: 18, color: Colors.black54),
//               const SizedBox(width: 8),
//               Text(
//                 workData["name"] ?? "Student Name",
//                 style: const TextStyle(fontSize: 14, color: Colors.black87),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),

//           // Work Hours
//           Row(
//             children: [
//               const Icon(Icons.access_time, size: 18, color: Colors.black54),
//               const SizedBox(width: 8),
//               Text(
//                 "$hours hours",
//                 style: const TextStyle(fontSize: 14, color: Colors.black87),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),

//           // Date
//           Row(
//             children: [
//               const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
//               const SizedBox(width: 8),
//               Text(
//                 date,
//                 style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.black87,
//                     fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),

//           // Approve / Reject Buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10))),
//                 onPressed: onApprove,
//                 child: const Text("Approve"),
//               ),
//               const SizedBox(width: 12),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10))),
//                 onPressed: onReject,
//                 child: const Text("Reject"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class StudentCard extends StatelessWidget {
//   final Map<String, dynamic> data;
//   final VoidCallback? onTap;

//   const StudentCard({
//     super.key,
//     required this.data,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final totalHours = data["totalHours"] ?? 0;

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 8,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Name
//             Text(
//               data["name"] ?? "Student Name",
//               style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87),
//             ),
//             const SizedBox(height: 8),

//             // Email
//             Row(
//               children: [
//                 const Icon(Icons.email, size: 18, color: Colors.black54),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     data["email"] ?? "student@email.com",
//                     style: const TextStyle(color: Colors.black87, fontSize: 14),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 6),

//             // Phone
//             Row(
//               children: [
//                 const Icon(Icons.phone, size: 18, color: Colors.black54),
//                 const SizedBox(width: 8),
//                 Text(
//                   data["mobile"] ?? "-",
//                   style: const TextStyle(color: Colors.black87, fontSize: 14),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 6),

//             // Total Work Hours
//             Row(
//               children: [
//                 const Icon(Icons.access_time, size: 18, color: Colors.black54),
//                 const SizedBox(width: 8),
//                 Text(
//                   " Total: $totalHours hours",
//                   style: const TextStyle(
//                       color: Colors.black87,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }import 'dart:async';



import 'package:earn_and_learn_project/HOD/studworkdetails.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/auth_utils.dart';
import '../student_details_page.dart';
import 'dart:async';

class HodDashboard extends StatefulWidget {
  final String uid;

  const HodDashboard({super.key, required this.uid});

  @override
  State<HodDashboard> createState() => _HodDashboardState();
}

class _HodDashboardState extends State<HodDashboard> {

  late DatabaseReference _hodRef;
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref("users");

  Map<String, dynamic>? hodData;

  StreamSubscription? _subscription;

  List<Map<String, dynamic>> allEntries = [];
  List<Map<String, dynamic>> uniqueStudents = [];

  bool isLoading = true;

  // ================= UPDATE STATUS =================
void _updateWorkStatus(
  String uid,
  String workKey,
  String status,
) {
  _usersRef
      .child(uid)
      .child("workEntries")
      .child(workKey)
      .update({"status": status});
}

  // ================= INIT =================
  @override
  void initState() {
    super.initState();

    _hodRef = FirebaseDatabase.instance.ref("hods/${widget.uid}");

    _hodRef.once().then((snapshot) {
      if (snapshot.snapshot.value != null) {
        hodData =
            Map<String, dynamic>.from(snapshot.snapshot.value as Map);

        _listenToEntries();
      }
    });
  }

  // ================= LISTEN DATA =================
  void _listenToEntries() {
    final hodDept =
        (hodData?["department"] ?? "").toString().toLowerCase().trim();

    _subscription = _usersRef.onValue.listen((event) {

      final List<Map<String, dynamic>> entriesList = [];
      final Map<String, Map<String, dynamic>> studentsMap = {};

      if (event.snapshot.value != null) {

        final users =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        users.forEach((uid, userRaw) {

          final user = Map<String, dynamic>.from(userRaw);

          final dept =
              (user["workingDepartment"] ?? "").toString().toLowerCase().trim();

          if (dept != hodDept) return;

          double totalHours = 0;

          if (user["workEntries"] != null) {

            final workEntries =
                Map<String, dynamic>.from(user["workEntries"]);

            workEntries.forEach((workKey, workRaw)  {

              final work = Map<String, dynamic>.from(workRaw);

             final status =
    work["status"]?.toString().toLowerCase();

/// count only verified/approved hours
if (status?.startsWith("approved") == true ||
    status == "verified_by_hod") {
  totalHours +=
      double.tryParse(work["hours"]?.toString() ?? "0") ?? 0;
}
if (status == null) return;
              entriesList.add({
                "uid": uid,
                 "workKey": workKey,
                "name": user["name"],
                "email": user["email"],
                "mobile": user["mobile"] ?? "-",
                "title": work["title"],
                "hours": work["hours"],
                "date": work["date"],
                "status": work["status"],
              });
            });
          }

          studentsMap[uid] = {
            "uid": uid,
            "name": user["name"],
            "email": user["email"],
            "mobile": user["mobile"] ?? "-",
            "totalHours": totalHours,
          };
        });
      }

      setState(() {
        allEntries = entriesList;
        uniqueStudents = studentsMap.values.toList();
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {

    final pendingEntries = allEntries.where((e) =>
        e["status"]?.toString().toLowerCase() == "approved_by_sub").toList();

    final verifiedStudents = uniqueStudents.where((student) {

      return allEntries.any((entry) =>
          entry["uid"] == student["uid"] &&
          entry["status"] == "verified_by_hod");
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E3D),
        foregroundColor: Colors.white,
        title: const Text("HOD Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthUtils.showLogoutDialog(context),
          )
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [

                  _profileCard(),

                  _statsRow(
                    uniqueStudents.length,
                    pendingEntries.length,
                    verifiedStudents.length,
                  ),

                  /// ================= PENDING =================
                  _sectionHeader(
                      "Pending Verification", Icons.assignment, Colors.orange),

                  pendingEntries.isEmpty
                      ? _emptyCard("No pending verification")
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pendingEntries.length,
                          itemBuilder: (context, index) {

                            final e = pendingEntries[index];

                            return _verificationCard(e);
                          },
                        ),

                  /// ================= VERIFIED =================
                  _sectionHeader(
                      "Verified Students", Icons.verified, Colors.green),

                  verifiedStudents.isEmpty
                      ? _emptyCard("No verified students")
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: verifiedStudents.length,
                          itemBuilder: (context, index) =>
                              _studentCard(context, verifiedStudents[index]),
                        ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

// ================= PREMIUM VERIFY CARD =================
Widget _verificationCard(Map<String, dynamic> e) {

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.06),
          blurRadius: 12,
          offset: const Offset(0, 5),
        )
      ],
    ),

    child: Row(
      children: [

        /// ✅ LEFT ACCENT BAR (PREMIUM TOUCH)
        Container(
          width: 4,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        const SizedBox(width: 14),

        /// ================= DETAILS =================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TITLE
              Text(
                e["title"] ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 6),

              /// STUDENT
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      e["name"] ?? "",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              /// HOURS + DATE
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 15, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    "${e["hours"]} hrs",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(width: 14),

                  Icon(Icons.calendar_today,
                      size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    e["date"] ?? "",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        /// ================= VERIFY BUTTON =================
        InkWell(
          onTap: () {

         _updateWorkStatus(
    e["uid"],
    e["workKey"],
    "verified_by_hod",
);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                content: const Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Work Verified Successfully",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },

          borderRadius: BorderRadius.circular(14),

          child: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.green.withOpacity(.35),
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.green,
              size: 22,
            ),
          ),
        ),
      ],
    ),
  );
}
  // ================= PROFILE =================
  Widget _profileCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF1B3A68), Color(0xFF0B1E3D)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white24,
              child: Text(
                (hodData?["name"] ?? "H")[0],
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 15),
            Text(hodData?["name"] ?? "HOD",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ================= STATS =================
  Widget _statsRow(int students, int pending, int verified) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _dashboardCard("Students", "$students", Colors.blue, Icons.people),
          const SizedBox(width: 10),
          _dashboardCard("Pending", "$pending", Colors.orange, Icons.pending),
          const SizedBox(width: 10),
          _dashboardCard("Verified", "$verified", Colors.green, Icons.verified),
        ],
      ),
    );
  }

  Widget _dashboardCard(
      String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [color.withOpacity(.6), color.withOpacity(.3)]),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(title,
                style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
      String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _emptyCard(String text) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child:
            Text(text, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }
}

// ================= STUDENT CARD =================
Widget _studentCard(
    BuildContext context,
    Map<String, dynamic> data,
    {int index = 0}) {

  final totalHours = data["totalHours"] ?? 0;

  return InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StudentDetailPage(
            studentUid: data["uid"],
            studentName: data["name"],
          ),
        ),
      );
    },

    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
  
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [

          /// Avatar
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blue.shade50,
            child: const Icon(Icons.person, color: Colors.blue),
          ),

          const SizedBox(width: 14),

          /// Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  data["name"] ?? "",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  data["email"] ?? "",
                  style: TextStyle(color: Colors.grey.shade700),
                ),

                const SizedBox(height: 6),

                // Text(
                //   "Total Hours: $totalHours",
                //   style: const TextStyle(
                //     fontWeight: FontWeight.w600,
                //     color: Colors.blue,
                //   ),
                // ),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios, size: 16)
        ],
      ),
    ),
  );
}