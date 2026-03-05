// import 'dart:async';
// import 'package:earn_and_learn_project/HOD/studworkdetails.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import '../utils/auth_utils.dart';
// import '../student_details_page.dart';
// import '../work_request.dart';

// class SubCoordinatorDashboard extends StatefulWidget {
//   final String uid;

//   const SubCoordinatorDashboard({super.key, required this.uid});

//   @override
//   State<SubCoordinatorDashboard> createState() =>
//       _SubCoordinatorDashboardState();
// }

// class _SubCoordinatorDashboardState
//     extends State<SubCoordinatorDashboard>
//     with SingleTickerProviderStateMixin {

//   late DatabaseReference _subRef;
//   final DatabaseReference _usersRef =
//       FirebaseDatabase.instance.ref("users");

//   Map<String, dynamic>? subData;
//   StreamSubscription? _subscription;

//   List<Map<String, dynamic>> allEntries = [];
//   List<Map<String, dynamic>> uniqueStudents = [];

//   bool isLoading = true;
//   String searchQuery = "";

//   late TabController _tabController;

//   // ✅ UPDATE STATUS
//   void _updateWorkStatus(String uid, String title, String status) {
//     final userRef = _usersRef.child(uid).child("workEntries");

//     userRef.once().then((snapshot) {
//       if (snapshot.snapshot.value == null) return;

//       final works =
//           Map<String, dynamic>.from(snapshot.snapshot.value as Map);

//       works.forEach((key, workRaw) {
//         final work = Map<String, dynamic>.from(workRaw);

//         if (work["title"] == title) {
//           userRef.child(key).update({"status": status});
//         }
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     _tabController = TabController(length: 2, vsync: this);

//     /// ✅ CORRECT PATH
//     _subRef = FirebaseDatabase.instance
//         .ref("sub_coordinators/${widget.uid}");

//     _subRef.once().then((snapshot) {
//       if (snapshot.snapshot.value != null) {
//         subData =
//             Map<String, dynamic>.from(snapshot.snapshot.value as Map);

//         _listenEntries();
//       }
//     });
//   }

//   // ✅ LISTEN STUDENT DATA
//   void _listenEntries() {

//     final subDept =
//         (subData?["department"] ?? "").toString().toLowerCase();

//     _subscription = _usersRef.onValue.listen((event) {

//       final List<Map<String, dynamic>> entriesList = [];
//       final Map<String, Map<String, dynamic>> studentsMap = {};

//       if (event.snapshot.value != null) {

//         final users =
//             Map<String, dynamic>.from(event.snapshot.value as Map);

//         users.forEach((uid, userRaw) {

//           final user = Map<String, dynamic>.from(userRaw);
//           final dept =
//               (user["department"] ?? "").toString().toLowerCase();

//           /// ✅ Department filter
//           if (dept != subDept) return;

//           double totalHours = 0;

//           if (user["workEntries"] != null) {

//             final workEntries =
//                 Map<String, dynamic>.from(user["workEntries"]);

//             workEntries.forEach((_, workRaw) {

//               final work = Map<String, dynamic>.from(workRaw);

//               totalHours +=
//                   double.tryParse(work["hours"]?.toString() ?? "0") ?? 0;

//               entriesList.add({
//                 "uid": uid,
//                 "name": user["name"],
//                 "email": user["email"],
//                 "mobile": user["mobile"] ?? "-",
//                 "department": user["department"],
//                 "title": work["title"],
//                 "hours": work["hours"],
//                 "date": work["date"],
//                 "status": work["status"],
//               });
//             });
//           }

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

//     /// ✅ ONLY PENDING FOR SUB COORDINATOR
//     final pendingEntries = allEntries.where((e) =>
//         e["status"]?.toString().toLowerCase() == "pending").toList();

//     final totalStudents = uniqueStudents.length;
//     final pendingCount = pendingEntries.length;

//     return Scaffold(
//       // backgroundColor: const Color(0xFF0B1E3D),
// backgroundColor: const Color(0xFF0F172A), // dark slate
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0B1E3D),
//         foregroundColor: Colors.white,
//         title: const Text("Sub-Coordinator Dashboard",
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               AuthUtils.showLogoutDialog(context);
//             },
//           )
//         ],
//       ),

//       body: Column(
//         children: [

//           /// PROFILE CARD (Same as HOD)
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                gradient: const LinearGradient(
//   colors: [Color(0xFFFF8C00), Color(0xFFFFB347)],
// ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.white24,
//                     child: Text(
//                       subData?["name"] != null
//                           ? subData!["name"][0]
//                           : "S",
//                       style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(subData?["name"] ?? "",
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold)),
//                           Text(subData?["email"] ?? "",
//                               style:
//                                   const TextStyle(color: Colors.white70)),
//                           Text(subData?["department"] ?? "",
//                               style:
//                                   const TextStyle(color: Colors.white70)),
//                         ]),
//                   )
//                 ],
//               ),
//             ),
//           ),

//           /// STATS (Same as HOD)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 _dashboardCard("Total Students",
//                     "$totalStudents", Colors.blue, Icons.people),
//                 const SizedBox(width: 12),
//                 _dashboardCard("Pending",
//                     "$pendingCount", Colors.orange, Icons.pending),
//               ],
//             ),
//           ),

//           const SizedBox(height: 15),

//           /// TABS
//           TabBar(
//             controller: _tabController,
//             indicator: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(5)),
//             labelColor: Colors.black87,
//             unselectedLabelColor: Colors.white70,
//             tabs: const [
//               Tab(text: "New Requests"),
//               Tab(text: "All Students"),
//             ],
//           ),

//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [

//                 /// REQUESTS TAB
//                 isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : ListView.builder(
//                         itemCount: pendingEntries.length,
//                         itemBuilder: (context, index) {
//                           final e = pendingEntries[index];

//                           return WorkRequestCard(
//                             workData: e,
//                             onApprove: () {
//                               _updateWorkStatus(
//                                   e["uid"], e["title"],
//                                   "approved_by_sub");
//                             },
//                             onReject: () {
//                               _updateWorkStatus(
//                                   e["uid"], e["title"],
//                                   "rejected");
//                             },
//                           );
//                         },
//                       ),

//                 /// STUDENTS TAB
//        /// STUDENTS TAB
// isLoading
//     ? const Center(child: CircularProgressIndicator())
//     : uniqueStudents.isEmpty
//         ? const Center(
//             child: Text(
//               "No students found",
//               style: TextStyle(color: Colors.white70),
//             ),
//           )
//         : ListView.builder(
//             itemCount: uniqueStudents.length,
//             itemBuilder: (context, index) {
//               final e = uniqueStudents[index];
// return _studentCard(context, e);

//             },
//           ),

//               ],
//             ),
//           ),
//         ],
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
//               colors: [color.withOpacity(0.6), color.withOpacity(0.3)]),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: color),
//                 const SizedBox(width: 10),
//                 Text(value,
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: color)),
//               ],
//             ),
//             const SizedBox(height: 6),
//             Text(title,
//                 style: const TextStyle(color: Colors.white70)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// ✅ STUDENT CARD UI
// Widget _studentCard(BuildContext context, Map<String, dynamic> data) {
//   final totalHours = data["totalHours"] ?? 0;

//   return GestureDetector(
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => StudentDetailPage(
//             studentUid: data["uid"],
//             studentName: data["name"],
//           ),
//         ),
//       );
//     },
//     child: Container(
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

//           /// NAME
//           Text(
//             data["name"] ?? "Student",
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),

//           const SizedBox(height: 8),

//           /// EMAIL
//           Row(
//             children: [
//               const Icon(Icons.email, size: 18, color: Colors.black54),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   data["email"] ?? "",
//                   style: const TextStyle(color: Colors.black87),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 6),

//           /// PHONE
//           Row(
//             children: [
//               const Icon(Icons.phone, size: 18, color: Colors.black54),
//               const SizedBox(width: 8),
//               Text(
//                 data["mobile"] ?? "-",
//                 style: const TextStyle(color: Colors.black87),
//               ),
//             ],
//           ),

//           const SizedBox(height: 6),

//           /// HOURS
//           Row(
//             children: [
//               const Icon(Icons.access_time, size: 18, color: Colors.black54),
//               const SizedBox(width: 8),
//               Text(
//                 "Total: $totalHours hours",
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }


import 'dart:async';
import 'package:earn_and_learn_project/HOD/studworkdetails.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/auth_utils.dart';
import '../student_details_page.dart';
import '../work_request.dart';

class SubCoordinatorDashboard extends StatefulWidget {
  final String uid;

  const SubCoordinatorDashboard({super.key, required this.uid});

  @override
  State<SubCoordinatorDashboard> createState() =>
      _SubCoordinatorDashboardState();
}

class _SubCoordinatorDashboardState
    extends State<SubCoordinatorDashboard> {

  late DatabaseReference _subRef;
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref("users");

  Map<String, dynamic>? subData;
  StreamSubscription? _subscription;

  List<Map<String, dynamic>> allEntries = [];
  List<Map<String, dynamic>> uniqueStudents = [];

  bool isLoading = true;

  // ================= UPDATE STATUS =================
Future<void> _updateWorkStatus(
  String uid,
  String workKey,
  String status,
) async {
  await _usersRef
      .child(uid)
      .child("workEntries")
      .child(workKey)
      .update({"status": status});
}

  // ================= INIT =================
  @override
  void initState() {
    super.initState();

    _subRef =
        FirebaseDatabase.instance.ref("sub_coordinators/${widget.uid}");

    _subRef.once().then((snapshot) {
      if (snapshot.snapshot.value != null) {
        subData =
            Map<String, dynamic>.from(snapshot.snapshot.value as Map);

        _listenEntries();
      }
    });
  }

  // ================= LISTEN DATA =================
  void _listenEntries() {
    final subDept =
        (subData?["department"] ?? "").toString().toLowerCase();

    _subscription = _usersRef.onValue.listen((event) {
      final List<Map<String, dynamic>> entriesList = [];
      final Map<String, Map<String, dynamic>> studentsMap = {};

      if (event.snapshot.value != null) {
        final users =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        users.forEach((uid, userRaw) {
          final user = Map<String, dynamic>.from(userRaw);

          final dept =
              (user["workingDepartment"] ?? "").toString().toLowerCase();

          if (dept != subDept) return;

          double totalHours = 0;

          if (user["workEntries"] != null) {
            final workEntries =
                Map<String, dynamic>.from(user["workEntries"]);

           workEntries.forEach((workKey, workRaw)  {
              final work = Map<String, dynamic>.from(workRaw);

             final status =
    work["status"]?.toString().toLowerCase();

/// ✅ ONLY FINAL VERIFIED HOURS
if (status == "verified_by_hod") {
  totalHours +=
      double.tryParse(work["hours"]?.toString() ?? "0") ?? 0;
}

/// show only pending
if (status != "pending") return;
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
                 "createdAt": work["createdAt"] ?? 0,
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
entriesList.sort((a, b) {
  final aTime = a["createdAt"] ?? 0;
  final bTime = b["createdAt"] ?? 0;
  return bTime.compareTo(aTime);
});
      if (mounted) {

  setState(() {
    allEntries = List.from(entriesList);
    uniqueStudents = studentsMap.values.toList();
    isLoading = false;
  });
}
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

    // final pendingEntries = allEntries.where((e) =>
    //     e["status"]?.toString().toLowerCase() == "pending").toList();
final pendingEntries = allEntries;
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E3D),
        foregroundColor: Colors.white,
        title: const Text("Sub-Coordinator Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold)),
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
                  ),

                  _sectionHeader(
                      "Pending Requests", Icons.assignment, Colors.orange),

                  pendingEntries.isEmpty
                      ? _emptyCard("No pending requests")
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pendingEntries.length,
                  itemBuilder: (context, index) {
  final e = pendingEntries[index];

  return AnimatedWorkCard(
    index: index,

    onApprove: () async {
     _updateWorkStatus(
    e["uid"],
    e["workKey"],
    "approved_by_sub",
);
    },

    onReject: () async {
     _updateWorkStatus(
    e["uid"],
    e["workKey"],
    "rejected",
);
    },

    child: Builder(
      builder: (context) {

        final cardState =
            context.findAncestorStateOfType<
                AnimatedWorkCardState>();

        return Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                e["title"] ?? "Work",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text("Student: ${e["name"]}"),
              Text("Hours: ${e["hours"]}"),
              Text("Date: ${e["date"]}"),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  _roundedActionButton(
                    icon: Icons.close_rounded,
                    label: "Reject",
                    color: Colors.red,
                    onTap: () => cardState?.reject(),
                  ),

                  const SizedBox(width: 12),

                  _roundedActionButton(
  icon: Icons.check_rounded,
  label: "Approve",
  color: Colors.green,
  onTap: () async {
    await _updateWorkStatus(
      e["uid"],
      e["workKey"],
      "approved_by_sub",
    );
  },
),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
                          },
                        ),

                  _sectionHeader(
                      "Students", Icons.people, Colors.blue),

                  uniqueStudents.isEmpty
                      ? _emptyCard("No students found")
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: uniqueStudents.length,
                          itemBuilder: (context, index) =>
                              _studentCard(context, uniqueStudents[index]),
                        ),

                  const SizedBox(height: 30),
                ],
              ),
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
            colors: [Color(0xFFFF8C00), Color(0xFFFFB347)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white24,
              child: Text(
                subData?["name"]?[0] ?? "S",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subData?["name"] ?? "",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text(subData?["email"] ?? "",
                    style: const TextStyle(color: Colors.white70)),
                Text(subData?["department"] ?? "",
                    style: const TextStyle(color: Colors.white70)),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ================= STATS =================
  Widget _statsRow(int students, int pending) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _dashboardCard("Students", "$students",
              Colors.blue, Icons.people),
          const SizedBox(width: 12),
          _dashboardCard("Pending", "$pending",
              Colors.orange, Icons.pending),
        ],
      ),
    );
  }

  Widget _dashboardCard(
      String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [color.withOpacity(.6), color.withOpacity(.3)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(title,
                style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  // ================= SECTION HEADER =================
  Widget _sectionHeader(
      String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _emptyCard(String text) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(text,
            style: const TextStyle(color: Colors.white70)),
      ),
    );
  }
}
class AnimatedEntry extends StatelessWidget {
  final Widget child;
  final int index;

  const AnimatedEntry({
    super.key,
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 80)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
class AnimatedWorkCard extends StatefulWidget {
  final Widget child;
  final int index;
  final Future<void> Function()? onApprove;
  final Future<void> Function()? onReject;

  const AnimatedWorkCard({
    super.key,
    required this.child,
    required this.index,
    this.onApprove,
    this.onReject,
  });

  @override
  State<AnimatedWorkCard> createState() =>
      AnimatedWorkCardState();
}

class AnimatedWorkCardState extends State<AnimatedWorkCard>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  bool _isRemoving = false;
  Color overlayColor = Colors.transparent;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _controller.forward();
  }

  Future<void> approve() async {
    await _handleAction(widget.onApprove, Colors.green);
  }

  Future<void> reject() async {
    await _handleAction(widget.onReject, Colors.red);
  }

Future<void> _handleAction(
    Future<void> Function()? action,
    Color color) async {

  if (_isRemoving) return;

  setState(() {
    _isRemoving = true;
  });

  /// small delay for button press feel
  await Future.delayed(const Duration(milliseconds: 200));

  if (action != null) await action();

  /// ✅ SHOW SUCCESS SNACKBAR
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Row(
          children: [
            Icon(
              color == Colors.green
                  ? Icons.check_circle
                  : Icons.cancel,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              color == Colors.green
                  ? "Work Approved Successfully"
                  : "Work Rejected",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// animate card removal
  if (mounted) {
    await _controller.reverse();
  }
}

  @override
@override
Widget build(BuildContext context) {

  final fade = CurvedAnimation(
      parent: _controller, curve: Curves.easeOut);

  final slide = Tween(
    begin: const Offset(0, .08),
    end: Offset.zero,
  ).animate(fade);

  return FadeTransition(
    opacity: fade,
    child: SlideTransition(
      position: slide,
      child: widget.child,
    ),
  );
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
// ================= STUDENT CARD =================
Widget _studentCard(BuildContext context, Map<String, dynamic> data,
    {int index = 0}) {
  final totalHours = data["totalHours"] ?? 0;

  return AnimatedEntry(
    index: index,
    child: InkWell(
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
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(data["email"] ?? "",
                      style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 6),
                  // Text(
                  //   "Total Hours: $totalHours",
                  //   style: const TextStyle(
                  //       fontWeight: FontWeight.w600,
                  //       color: Colors.blue),
                  // ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16)
          ],
        ),
      ),
    ),
  );
}
Widget _roundedActionButton({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(30),
    child: Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}