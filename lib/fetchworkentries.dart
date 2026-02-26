// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:elms/addworkpage.dart';

// class WorkEntriesPage extends StatefulWidget {
//   final String uid;
//   const WorkEntriesPage({super.key, required this.uid});

//   @override
//   State<WorkEntriesPage> createState() => _WorkEntriesPageState();
// }

// class _WorkEntriesPageState extends State<WorkEntriesPage> {
//   final user = FirebaseAuth.instance.currentUser;
//   final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

//   Future<void> _refresh() async {
//     setState(() {}); // simply refresh
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return const Scaffold(
//         body: Center(
//           child: Text('User not logged in'),
//         ),
//       );
//     }

//     // Reference to user's work entries
//     DatabaseReference workRef =
//         dbRef.child('users').child(user!.uid).child('workEntries');

//     return Scaffold(
//       backgroundColor: const Color(0xFF0E121F),

//       body: RefreshIndicator(
//         onRefresh: _refresh,
//         child: StreamBuilder(
//           stream: workRef.onValue,
//           builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             final data = snapshot.data!.snapshot.value;
//             if (data == null) {
//               return const Center(
//                 child: Text(
//                   'No work entries yet',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               );
//             }

//             // Realtime Database returns a Map
//             final Map<dynamic, dynamic> workMap = data as Map<dynamic, dynamic>;
//             final workList = workMap.entries.toList(); // Convert to list for ListView

//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: workList.length,
//               itemBuilder: (context, index) {
//                 final key = workList[index].key;
//                 final entry = Map<String, dynamic>.from(workList[index].value);

//                 return Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   color: const Color(0xFF1A1F2E),
//                   margin: const EdgeInsets.only(bottom: 16),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           entry['title'] ?? '',
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Workplace: ${entry['workplace'] ?? ''}',
//                           style: const TextStyle(color: Colors.white70),
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Date: ${entry['date'] ?? ''}',
//                               style: const TextStyle(color: Colors.white70),
//                             ),
//                             Text(
//                               '${entry['hours'] ?? '0'} hrs',
//                               style: const TextStyle(color: Colors.white70),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Status: ${entry['status'] ?? 'Pending'}',
//                           style: TextStyle(
//                               color: entry['status'] == 'Pending'
//                                   ? Colors.orange
//                                   : Colors.green),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           entry['description'] ?? '',
//                           style: const TextStyle(color: Colors.white70),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),

//       // Floating Action Button to Add Entry
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.blue.shade600,
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           final newWork = await Navigator.push<WorkEntry>(
//             context,
//             MaterialPageRoute(builder: (_) => const AddWorkEntryPage()),
//           );

//           if (newWork != null) {
//             DatabaseReference workRef = dbRef
//                 .child('users')
//                 .child(user!.uid)
//                 .child('workEntries');
//             await workRef.push().set(newWork.toMap());
//           }
//         },
//       ),
//     );
//   }
// }

//   /// ---------------- DETAILS ----------------
//   void _showWorkDetails(WorkEntry work) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: Text(work.title),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Date: ${work.date}"),
//             Text("From: ${work.fromTime}"),
//             Text("To: ${work.toTime}"),
//             Text("Hours: ${work.hours}"),
//             const SizedBox(height: 8),
//             Text(
//               "Status: ${work.status}",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Text(work.description),
//           ],
//         ),
//       ),
//     );
//   }

//   void _editWork(WorkEntry work) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Edit ${work.title} (logic pending)")),
//     );
//   }

//   void _confirmDelete(WorkEntry work) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Delete Work"),
//         content: Text("Delete '${work.title}' permanently?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               await _deleteWork(work);
//               Navigator.pop(context);
//             },
//             child: const Text("Delete"),
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> _deleteWork(WorkEntry work) async {
//     final snapshot = await workRef.get();
//     if (!snapshot.exists) return;

//     final data = snapshot.value as Map<dynamic, dynamic>;

//     for (final entry in data.entries) {
//       if (entry.value["title"] == work.title &&
//           entry.value["date"] == work.date) {
//         await workRef.child(entry.key).remove();
//         break;
//       }
//     }
//   }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'addworkpage.dart';
import 'work_entry.dart';

class WorkEntriesPage extends StatefulWidget {
  final String uid;
  const WorkEntriesPage({super.key, required this.uid});

  @override
  State<WorkEntriesPage> createState() => _WorkEntriesPageState();
}

class _WorkEntriesPageState extends State<WorkEntriesPage> {
  final user = FirebaseAuth.instance.currentUser;
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  late DatabaseReference workRef;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      workRef = dbRef.child('users').child(user!.uid).child('workEntries');
    }
  }
String formatStatus(String? status) {
  if (status == null) return "Pending";

  switch (status.toLowerCase()) {
    case "approved_by_sub":
      return "Approved by Sub Coordinator";

    case "verified_by_hod":
      return "Verified by HOD";

    case "pending":
      return "Pending";

    case "rejected":
      return "Rejected";

    default:
      return status;
  }
}
Color statusColor(String? status) {
  switch (status?.toLowerCase()) {
    case "verified_by_hod":
      return Colors.green;

    case "approved_by_sub":
      return Colors.blue;

    case "pending":
      return Colors.orange;

    case "rejected":
      return Colors.red;

    default:
      return Colors.grey;
  }
}
  Future<void> _refresh() async {
    setState(() {});
  }
  

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
         resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF0E121F),
        body: Center(
          child: Text(
            'User not logged in',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: StreamBuilder(
          stream: workRef.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading work entries: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final data = snapshot.data!.snapshot.value;
            if (data == null) {
              return const Center(
                child: Text(
                  'No work entries yet',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              );
            }

            final Map<dynamic, dynamic> workMap = data as Map<dynamic, dynamic>;
            final workList = workMap.entries.toList();

            return ListView.builder(
              padding: const EdgeInsets.all(5),
              itemCount: workList.length,
              itemBuilder: (context, index) {
                final key = workList[index].key;
                final entry = Map<String, dynamic>.from(workList[index].value);
                final work = WorkEntry.fromMap(entry, key);

                return GestureDetector(
                  onTap: () => _showWorkDetails(work),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Card(
  elevation: 8,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 TITLE + STATUS
        Row(
          children: [
            Expanded(
              child: Text(
                work.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
           Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: statusColor(work.status).withOpacity(.15),
    borderRadius: BorderRadius.circular(14),
  ),
  child: Text(
    formatStatus(work.status),
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: statusColor(work.status),
    ),
  ),
),
          ],
        ),

        const SizedBox(height: 6),

        /// 🔹 WORKPLACE + DATE
        Row(
          children: [
            const Icon(Icons.work, size: 16, color: Colors.black54),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                work.workplace,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            const Icon(Icons.date_range, size: 16, color: Colors.black54),
            const SizedBox(width: 4),
            Text(
              work.date,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),

        const SizedBox(height: 6),

        /// 🔹 HOURS + ACTIONS
        Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.black54),
            const SizedBox(width: 4),
            Text(
              "${work.hours} hrs",
              style: const TextStyle(color: Colors.black54),
            ),
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => _editWork(work),
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
            ),
           
          ],
        ),
      ],
    ),
  ),
),

                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
         FocusScope.of(context).unfocus();

await Future.delayed(const Duration(milliseconds: 50));

if (!context.mounted) return;

Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const AddWorkEntryPage()),
);

        },
      ),
    );
  }

  /// ---------------- DETAILS ----------------
void _showWorkDetails(WorkEntry work) {
  final isApproved = work.status.toLowerCase() == "approved";

  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2FB8FF), // Sky Blue
              Color(0xFF0E121F), // Black
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 TITLE + STATUS
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        work.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isApproved
                            ? Colors.green.withOpacity(0.9)
                            : Colors.amber.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
  formatStatus(work.status),
  style: const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  ),
),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                /// 🔹 BASIC DETAILS
                _detailRow(Icons.work, "Workplace", work.workplace),
                _detailRow(Icons.calendar_today, "Date", work.date),
                _detailRow(Icons.schedule, "From", work.fromTime),
                _detailRow(Icons.schedule_outlined, "To", work.toTime),
                _detailRow(Icons.timer, "Total Hours", work.hours),

                const SizedBox(height: 18),

                /// 🔹 DESCRIPTION HEADER
                const Text(
                  "Description",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                /// 🔹 DESCRIPTION BOX
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    work.description.isNotEmpty
                        ? work.description
                        : "No description provided.",
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                /// 🔹 CLOSE BUTTON
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "CLOSE",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _detailRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Text(
          "$label:",
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

  /// ---------------- EDIT FUNCTION ----------------
  void _editWork(WorkEntry work) async {
    final editedWork = await Navigator.push<WorkEntry>(
      context,
      MaterialPageRoute(
        builder: (_) => AddWorkEntryPage(workToEdit: work),
      ),
    );

    if (editedWork != null) {
      await workRef.child(work.key).update(editedWork.toMap());
    }
  }

  /// ---------------- DELETE FUNCTION ----------------
  void _confirmDelete(WorkEntry work) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: const Text("Delete Work", style: TextStyle(color: Colors.white)),
        content: Text(
          "Delete '${work.title}' permanently?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: _isDeleting ? null : () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: _isDeleting ? null : () async {
              setState(() {
                _isDeleting = true;
              });
              try {
                await workRef.child(work.key).remove();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Work entry deleted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting entry: $e')),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() {
                    _isDeleting = false;
                  });
                }
              }
            },
            child: _isDeleting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
