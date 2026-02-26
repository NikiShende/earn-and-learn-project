// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';

// /// ---------------- WORK MODEL ----------------
// class WorkEntry {
//   final String title;
//   final String date;
//   final String fromTime;
//   final String toTime;
//   final String hours;
//   final String status;
//   final String description;

//   WorkEntry({
//     required this.title,
//     required this.date,
//     required this.fromTime,
//     required this.toTime,
//     required this.hours,
//     required this.status,
//     required this.description,
//   });
// }

// /// ---------------- DASHBOARD ----------------
// class Studdashboard extends StatefulWidget {
//   final String uid;
//   const Studdashboard({super.key, required this.uid});

//   @override
//   State<Studdashboard> createState() => _StuddashboardState();
// }

// class _StuddashboardState extends State<Studdashboard>

//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _fade;
//  late DatabaseReference userRef;
//   late DatabaseReference workRef;
// final List<WorkEntry> workList = [];

// void _loadWorkEntries() {
//   workRef.onValue.listen((event) {
//     final data = event.snapshot.value;
//     if (data == null) {
//       setState(() => workList.clear());
//       return;
//     }

//     final Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
//     final List<WorkEntry> loaded = [];

//     map.forEach((key, value) {
//       loaded.add(
//         WorkEntry(
//           title: value["title"],
//           date: value["date"],
//           fromTime: value["fromTime"],
//           toTime: value["toTime"],
//           hours: value["hours"],
//           status: value["status"],
//           description: value["description"],
//         ),
//       );
//     });

//     setState(() {
//       workList
//         ..clear()
//         ..addAll(loaded.reversed);
//     });
//   });
// }

//   @override
//   void initState() {
//     super.initState();
//      userRef = FirebaseDatabase.instance.ref("users/${widget.uid}");
//     workRef = FirebaseDatabase.instance.ref("works/${widget.uid}");
//     @override
// void initState() {
//   super.initState();

//   _controller =
//       AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
//   _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//   _controller.forward();

//   final uid = FirebaseAuth.instance.currentUser!.uid;
//   workRef = FirebaseDatabase.instance.ref("work_entries/$uid");

//   _loadWorkEntries();
// }

//     _controller =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
//     _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   /// ---------------- WORK CARD ----------------
//   Widget workCard(WorkEntry work) {
//     final bool approved = work.status == "Approved";

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.white, Colors.grey.shade50],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: approved
//                       ? [Colors.green.shade400, Colors.green.shade600]
//                       : [Colors.orange.shade400, Colors.orange.shade600],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: (approved ? Colors.green : Colors.orange).withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Icon(Icons.work_outline, color: Colors.white, size: 24),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(12),
//                 onTap: () => _showWorkDetails(work),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(work.title,
//                           style: const TextStyle(
//                               fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87)),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
//                           const SizedBox(width: 4),
//                           Text(work.date, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
//                           const SizedBox(width: 16),
//                           Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
//                           const SizedBox(width: 4),
//                           Text("${work.hours}h", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit_outlined, size: 20, color: Colors.blue.shade600),
//                     onPressed: () => _editWork(work),
//                     tooltip: 'Edit',
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete_outline, size: 20, color: Colors.red.shade600),
//                     onPressed: () => _deleteWork(work),
//                     tooltip: 'Delete',
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showWorkDetails(WorkEntry work) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         elevation: 16,
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.85,
//           constraints: const BoxConstraints(maxHeight: 450),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.white, Colors.grey.shade50],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             borderRadius: BorderRadius.circular(24),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: work.status == "Approved"
//                         ? [Colors.green.shade400, Colors.green.shade600]
//                         : [Colors.orange.shade400, Colors.orange.shade600],
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(24),
//                     topRight: Radius.circular(24),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.work, color: Colors.white, size: 24),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text("Work Details",
//                           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//               ),
//               Flexible(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _detailRow("Work Title", work.title, Icons.title),
//                       _detailRow("Date", work.date, Icons.calendar_today),
//                       _detailRow("From Time", work.fromTime, Icons.access_time),
//                       _detailRow("To Time", work.toTime, Icons.access_time_filled),
//                       _detailRow("Total Hours", "${work.hours} Hours", Icons.schedule),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
//                           const SizedBox(width: 8),
//                           const Text("Status", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//                           const SizedBox(width: 12),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: work.status == "Approved"
//                                     ? [Colors.green.shade100, Colors.green.shade200]
//                                     : [Colors.orange.shade100, Colors.orange.shade200],
//                               ),
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: work.status == "Approved" ? Colors.green.shade300 : Colors.orange.shade300,
//                               ),
//                             ),
//                             child: Text(work.status,
//                                 style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.bold,
//                                     color: work.status == "Approved" ? Colors.green.shade700 : Colors.orange.shade700)),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         children: [
//                           Icon(Icons.description, size: 16, color: Colors.grey.shade600),
//                           const SizedBox(width: 8),
//                           const Text("Description", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         child: Text(work.description,
//                             style: TextStyle(color: Colors.grey.shade700, fontSize: 14, height: 1.4)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _detailRow(String label, String value, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: Colors.grey.shade600),
//           const SizedBox(width: 8),
//           SizedBox(
//             width: 80,
//             child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(value, style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w500)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _editWork(WorkEntry work) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.edit, color: Colors.white),
//             const SizedBox(width: 8),
//             Text('Edit ${work.title}'),
//           ],
//         ),
//         backgroundColor: Colors.blue.shade600,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   void _deleteWork(WorkEntry work) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Icon(Icons.warning_amber_rounded, color: Colors.red.shade600, size: 28),
//             const SizedBox(width: 12),
//             const Text('Delete Work Entry', style: TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//         content: Text('Are you sure you want to delete "${work.title}"?\n\nThis action cannot be undone.',
//             style: const TextStyle(fontSize: 16)),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             child: const Text('Cancel', style: TextStyle(fontSize: 16)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                void _deleteWork(WorkEntry work) async {
//   final snapshot = await workRef.get();
//   if (!snapshot.exists) return;

//   final Map data = snapshot.value as Map;

//   for (var entry in data.entries) {
//     if (entry.value["title"] == work.title &&
//         entry.value["date"] == work.date) {
//       await workRef.child(entry.key).remove();
//       break;
//     }
//   }
// }

//               });
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Row(
//                     children: [
//                       const Icon(Icons.check_circle, color: Colors.white),
//                       const SizedBox(width: 8),
//                       Text('${work.title} deleted successfully'),
//                     ],
//                   ),
//                   backgroundColor: Colors.green,
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red.shade600,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//             child: const Text('Delete', style: TextStyle(color: Colors.white, fontSize: 16)),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ---------------- UI ----------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0E121F),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0E121F),
//         foregroundColor: Colors.white,
//         toolbarHeight: 80,
//         leading: IconButton(
//           icon: const Icon(Icons.menu),
//           onPressed: () {
//             Scaffold.of(context).openDrawer();
//           },
//         ),
//         centerTitle: true,
//         elevation: 0,
//         title: const Text("Student Dashboard"),
//       ),
//       floatingActionButton: FloatingActionButton(
// onPressed: () async {
//   final newWork = await Navigator.push<WorkEntry>(
//     context,
//     MaterialPageRoute(builder: (_) => const AddWorkEntryPage()),
//   );

//   if (newWork != null) {
//     final newRef = workRef.push();
//     await newRef.set({
//       "title": newWork.title,
//       "date": newWork.date,
//       "fromTime": newWork.fromTime,
//       "toTime": newWork.toTime,
//       "hours": newWork.hours,
//       "status": "Pending",
//       "description": newWork.description,
//       "createdAt": DateTime.now().toIso8601String(),
//     });
//   }
// },
//  backgroundColor: Colors.blue.shade600,
//         child: const Icon(Icons.add, size: 28),
//       ),
//       body: StreamBuilder(
//         stream: workRef.onValue,
//         builder: (context, snapshot) {
//            if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//            final data =
//               snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

//           if (data == null) {
//             return const Center(child: Text("No work assigned"));
//           }
//            // 🔹 Separate works by status
//           final pending = <Map>[];
//           final accepted = <Map>[];
//           final history = <Map>[];

//           data.forEach((key, value) {
//             if (value["status"] == "pending") pending.add(value);
//             if (value["status"] == "accepted") accepted.add(value);
//             if (value["status"] == "completed") history.add(value);
//           });
//           return FadeTransition(
//             opacity: _fade,
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// PROFILE
//                   Card(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Row(
//                         children: const [
//                           CircleAvatar(
//                             radius: 36,
//                             backgroundColor: Color(0xFF0E121F),
//                             child:
//                                 Icon(Icons.person, color: Colors.white, size: 40),
//                           ),
//                           SizedBox(width: 16),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Rahul Sharma",
//                                   style: TextStyle(
//                                       fontSize: 18, fontWeight: FontWeight.bold)),
//                               Text("B.E • 3rd Year"),
//                               Text("Computer Science"),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   /// SUMMARY
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               children: [
//                                 const Text("Approved Hours",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w600)),
//                                 const SizedBox(height: 12),
//                                 TweenAnimationBuilder<double>(
//                                   tween: Tween(begin: 0, end: 0.75),
//                                   duration:
//                                       const Duration(milliseconds: 1200),
//                                   builder: (_, value, __) {
//                                     return Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         SizedBox(
//                                           height: 90,
//                                           width: 90,
//                                           child: CircularProgressIndicator(
//                                             value: value,
//                                             strokeWidth: 8,
//                                             backgroundColor:
//                                                 Colors.grey.shade300,
//                                             valueColor:
//                                                 const AlwaysStoppedAnimation(
//                                                     Colors.green),
//                                           ),
//                                         ),
//                                         Text(
//                                           "${(value * 200).toInt()}",
//                                           style: const TextStyle(
//                                               fontSize: 22,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.green),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                                 const SizedBox(height: 6),
//                                 const Text("Hours"),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               children: const [
//                                 Text("Pending Requests",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w600)),
//                                 SizedBox(height: 20),
//                                 Icon(Icons.pending_actions,
//                                     size: 36, color: Colors.orange),
//                                 SizedBox(height: 6),
//                                 Text("1",
//                                     style: TextStyle(
//                                         fontSize: 36,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.orange)),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 25),

//                   const Text("Work History",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600)),
//                   const SizedBox(height: 12),

//                   ...workList.map(workCard).toList(),
//                 ],
//               ),
//             ),
//           );
//         }
//       ),
//     );
//   }
// }

// /// ---------------- ADD WORK ENTRY PAGE ----------------
// class AddWorkEntryPage extends StatefulWidget {
//   const AddWorkEntryPage({super.key});

//   @override
//   State<AddWorkEntryPage> createState() => _AddWorkEntryPageState();
// }

// class _AddWorkEntryPageState extends State<AddWorkEntryPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   DateTime _selectedDate = DateTime.now();
//   TimeOfDay _fromTime = TimeOfDay.now();
//   TimeOfDay _toTime = TimeOfDay.now();

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   String _formatDate(DateTime date) {
//     return "${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}";
//   }

//   String _getMonthName(int month) {
//     const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//     return months[month - 1];
//   }

//   String _formatTime(TimeOfDay time) {
//     final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     final minute = time.minute.toString().padLeft(2, '0');
//     final period = time.period == DayPeriod.am ? 'AM' : 'PM';
//     return '$hour:$minute $period';
//   }

//   int _calculateHours() {
//     final fromMinutes = _fromTime.hour * 60 + _fromTime.minute;
//     final toMinutes = _toTime.hour * 60 + _toTime.minute;
//     return ((toMinutes - fromMinutes) / 60).round();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0E121F),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0E121F),
//         title: const Text('Add Work Entry'),
//         centerTitle: true,
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Card(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextFormField(
//                         controller: _titleController,
//                         decoration: InputDecoration(
//                           labelText: 'Work Title',
//                           prefixIcon: const Icon(Icons.work_outline),
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                         validator: (value) => value?.isEmpty == true ? 'Please enter work title' : null,
//                       ),
//                       const SizedBox(height: 20),

//                       InkWell(
//                         onTap: () async {
//                           final date = await showDatePicker(
//                             context: context,
//                             initialDate: _selectedDate,
//                             firstDate: DateTime(2020),
//                             lastDate: DateTime(2030),
//                           );
//                           if (date != null) setState(() => _selectedDate = date);
//                         },
//                         child: InputDecorator(
//                           decoration: InputDecoration(
//                             labelText: 'Date',
//                             prefixIcon: const Icon(Icons.calendar_today),
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                           ),
//                           child: Text(_formatDate(_selectedDate)),
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       Row(
//                         children: [
//                           Expanded(
//                             child: InkWell(
//                               onTap: () async {
//                                 final time = await showTimePicker(context: context, initialTime: _fromTime);
//                                 if (time != null) setState(() => _fromTime = time);
//                               },
//                               child: InputDecorator(
//                                 decoration: InputDecoration(
//                                   labelText: 'From Time',
//                                   prefixIcon: const Icon(Icons.access_time),
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                 ),
//                                 child: Text(_formatTime(_fromTime)),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: InkWell(
//                               onTap: () async {
//                                 final time = await showTimePicker(context: context, initialTime: _toTime);
//                                 if (time != null) setState(() => _toTime = time);
//                               },
//                               child: InputDecorator(
//                                 decoration: InputDecoration(
//                                   labelText: 'To Time',
//                                   prefixIcon: const Icon(Icons.access_time_filled),
//                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                                 ),
//                                 child: Text(_formatTime(_toTime)),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),

//                       TextFormField(
//                         controller: _descriptionController,
//                         maxLines: 4,
//                         decoration: InputDecoration(
//                           labelText: 'Description',
//                           prefixIcon: const Icon(Icons.description),
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                         validator: (value) => value?.isEmpty == true ? 'Please enter description' : null,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       final newWork = WorkEntry(
//                         title: _titleController.text,
//                         date: _formatDate(_selectedDate),
//                         fromTime: _formatTime(_fromTime),
//                         toTime: _formatTime(_toTime),
//                         hours: _calculateHours().toString(),
//                         status: 'Pending',
//                         description: _descriptionController.text,
//                       );
//                       Navigator.pop(context, newWork);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue.shade600,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   ),
//                   child: const Text('Add Work Entry', style: TextStyle(fontSize: 16, color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'addworkpage.dart';
// import 'fetchworkentries.dart';
// import 'loginpage.dart';
// import 'utils/auth_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// /// ---------------- DASHBOARD ----------------
// class Studdashboard extends StatefulWidget {
//   final String uid;
//   const Studdashboard({super.key, required this.uid});

//   @override
//   State<Studdashboard> createState() => _StuddashboardState();
// }

// class _StuddashboardState extends State<Studdashboard>
//     with SingleTickerProviderStateMixin {
//   late DatabaseReference workRef;
//   bool _isLoggingOut = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future<void> _handleLogout() async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               AuthUtils.logout(context);
//             },
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ---------------- UI ----------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0E121F),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0E121F),
//         foregroundColor: Colors.white,
//         title: const Text("Student Dashboard",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
//         toolbarHeight: 80,

//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _handleLogout,
//           ),
//         ],
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ProfileCard(uid: widget.uid),
//             const SizedBox(height: 16),
//             SummaryCards(uid: widget.uid),
//             const SizedBox(height: 16),
//             const Text(
//               "Work History",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Expanded(
//               child: WorkEntriesPage(uid: widget.uid),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SummaryCards extends StatelessWidget {
//   final String uid;

//   const SummaryCards({super.key, required this.uid});

//   @override
//   Widget build(BuildContext context) {
//     final DatabaseReference workRef =
//         FirebaseDatabase.instance.ref("users/$uid/workEntries");

//     return StreamBuilder<DatabaseEvent>(
//       stream: workRef.onValue,
//       builder: (context, snapshot) {
//         int approvedHours = 0;
//         int pendingRequests = 0;

//         if (snapshot.hasData &&
//             snapshot.data!.snapshot.value != null) {
//           final entries =
//               Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

//           entries.forEach((key, value) {
//             final entry = Map<String, dynamic>.from(value as Map);

//             final hours = int.tryParse("${entry['hours'] ?? 0}") ?? 0;
//             final status = (entry['status'] ?? '').toString().toLowerCase();

//             if (status == "approved") {
//               approvedHours += hours;
//             } else if (status == "pending") {
//               pendingRequests += 1;
//             }
//           });
//         }

//         double progress = (approvedHours / 200).clamp(0.0, 1.0);

//         return Row(
//           children: [
//             // Approved Hours Card
//             Expanded(
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       const Text(
//                         "Approved Hours",
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(height: 12),
//                       TweenAnimationBuilder<double>(
//                         tween: Tween(begin: 0, end: progress),
//                         duration: const Duration(milliseconds: 1200),
//                         builder: (_, value, __) {
//                           return Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               SizedBox(
//                                 height: 90,
//                                 width: 90,
//                                 child: CircularProgressIndicator(
//                                   value: value,
//                                   strokeWidth: 8,
//                                   backgroundColor: Colors.grey.shade300,
//                                   valueColor: const AlwaysStoppedAnimation(
//                                       Colors.green),
//                                 ),
//                               ),
//                               Text(
//                                 "$approvedHours",
//                                 style: const TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.green),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 6),
//                       const Text("Hours"),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(width: 12),

//             // Pending Requests Card
//             Expanded(
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       const Text(
//                         "Pending Requests",
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(height: 20),
//                       const Icon(
//                         Icons.pending_actions,
//                         size: 36,
//                         color: Colors.orange,
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         "$pendingRequests",
//                         style: const TextStyle(
//                             fontSize: 36,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orange),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class ProfileCard extends StatelessWidget {
//   final String uid;

//   const ProfileCard({super.key, required this.uid});

//   @override
//   Widget build(BuildContext context) {
//     final DatabaseReference userRef =
//         FirebaseDatabase.instance.ref("users/$uid");

//     return StreamBuilder<DatabaseEvent>(
//       stream: userRef.onValue,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Padding(
//             padding: EdgeInsets.all(16),
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (!snapshot.hasData ||
//             snapshot.data!.snapshot.value == null) {
//           return const Padding(
//             padding: EdgeInsets.all(16),
//             child: Text("Profile not found"),
//           );
//         }

//         final data =
//             Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

//         final name = data['name'] ?? 'N/A';
//         final classYear = data['class'] ?? '';
//         final year = data['year'] ?? '';
//         final department = data['department'] ?? '';

//         return Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           margin: const EdgeInsets.all(16),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 36,
//                   backgroundColor: Color(0xFF0E121F),
//                   child:
//                       Icon(Icons.person, color: Colors.white, size: 40),
//                 ),
//                 const SizedBox(width: 16),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       "$classYear • $year",
//                       style: const TextStyle(color: Colors.black54),
//                     ),
//                     Text(
//                       department,
//                       style: const TextStyle(color: Colors.black54),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'about_app.dart';
import 'addworkpage.dart';
import 'fetchworkentries.dart';
import 'loginpage.dart';
import 'student_profile.dart';
import '../utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ---------------- DASHBOARD ----------------
class Studdashboard extends StatefulWidget {
  final String uid;
  const Studdashboard({super.key, required this.uid});

  @override
  State<Studdashboard> createState() => _StuddashboardState();
}

class _StuddashboardState extends State<Studdashboard>
    with SingleTickerProviderStateMixin {
  late DatabaseReference workRef;
  late Stream<DatabaseEvent> drawerStream;
  bool _isLoggingOut = false;
  Widget _buildPremiumTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Material(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          leading: Icon(icon, color: color),
          title: Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
  String formatStatus(String? status) {
  if (status == null) return "Pending";

  switch (status.toLowerCase()) {
    case "approved_by_sub":
      return "Approved by Sub Coordinator";

    case "verified_by_hod":
      return "Verified by HOD";

    case "pending":
      return "Pending Approval";

    case "rejected":
      return "Rejected";

    default:
      return status;
  }
}

  @override
  void initState() {
    super.initState();
    drawerStream = FirebaseDatabase.instance
        .ref("users/${widget.uid}")
        .onValue
        .asBroadcastStream();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AuthUtils.logout(context);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  /// ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                // Color.fromARGB(255, 34, 99, 121),
                Color.fromARGB(255, 0, 179, 255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔹 HEADER SECTION
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Color(0xFF2C5364),
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// Fetch Name Dynamically
                      StreamBuilder<DatabaseEvent>(
                        stream: drawerStream,
                        builder: (context, snapshot) {
                          String name = "Student";

                          if (snapshot.hasData &&
                              snapshot.data!.snapshot.value != null) {
                            final data = Map<String, dynamic>.from(
                              snapshot.data!.snapshot.value as Map,
                            );
                           name = data['name'] ?? "Student";
                          }
                          return Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 6),
                      const Text(
                        "Earn & Learn system",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const Divider(color: Colors.white30),

                /// 🔹 MENU ITEMS
                Expanded(
                  child: ListView(
                    children: [
                      _buildPremiumTile(
                        icon: Icons.dashboard,
                        title: "Dashboard",
                        onTap: () => Navigator.pop(context),
                      ),

                      _buildPremiumTile(
                        icon: Icons.person_outline,
                        title: "Profile",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StudentProfilePage(uid: widget.uid),
                            ),
                          );
                        },
                      ),

                      

                      _buildPremiumTile(
                        icon: Icons.logout,
                        title: "Logout",
                        color: Colors.redAccent,
                        onTap: _handleLogout,
                      ),
                    ],
                  ),
                ),

              
              ],
            ),
          ),
        ),
      ),

      backgroundColor: const Color(0xFF0B1E3D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E3D),
        foregroundColor: Colors.white,
        title: const Text(
          "Student Dashboard",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 60,

        automaticallyImplyLeading: true,
       
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileCard(uid: widget.uid),
            const SizedBox(height: 16),
            SummaryCards(uid: widget.uid),
            const SizedBox(height: 16),
            const Text(
              "Work History",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: StudentWorkSection(uid: widget.uid)),
          ],
        ),
      ),
    );
  }
}

class SummaryCards extends StatelessWidget {
  final String uid;

  const SummaryCards({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference workRef = FirebaseDatabase.instance.ref(
      "users/$uid/workEntries",
    );

    return StreamBuilder<DatabaseEvent>(
      stream: workRef.onValue,
      builder: (context, snapshot) {
        int approvedHours = 0;
        int pendingRequests = 0;

        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final entries = Map<String, dynamic>.from(
            snapshot.data!.snapshot.value as Map,
          );

          entries.forEach((key, value) {
            final entry = Map<String, dynamic>.from(value as Map);

            final hours = int.tryParse("${entry['hours'] ?? 0}") ?? 0;
            final status = (entry['status'] ?? '').toString().toLowerCase();

            if (status == "approved") {
              approvedHours += hours;
            } else if (status == "pending") {
              pendingRequests += 1;
            }
          });
        }

        double progress = (approvedHours / 200).clamp(0.0, 1.0);

        return Row(
          children: [
            // Approved Hours Card
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      const Text(
                        "Approved Hours",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 1200),
                        builder: (_, value, __) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 90,
                                width: 90,
                                child: CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: const AlwaysStoppedAnimation(
                                    Colors.green,
                                  ),
                                ),
                              ),
                              Text(
                                "$approvedHours",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 6),
                      const Text("Hours"),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Pending Requests Card
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "Pending Requests",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),
                      const Icon(
                        Icons.pending_actions,
                        size: 36,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "$pendingRequests",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String uid;

  const ProfileCard({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference userRef = FirebaseDatabase.instance.ref(
      "users/$uid",
    );

    return StreamBuilder<DatabaseEvent>(
      stream: userRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Profile not found"),
          );
        }

        final data = Map<String, dynamic>.from(
          snapshot.data!.snapshot.value as Map,
        );

        final name = data['name'] ?? 'N/A';
        final classYear = data['class'] ?? '';
        final year = data['year'] ?? '';
        final department = data['department'] ?? '';

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Welcome  ",
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "$name !",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      " Department : $department",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    Text(
                      " Class : $classYear",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StudentWorkSection extends StatelessWidget {
  final String uid;

  const StudentWorkSection({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference workRef = FirebaseDatabase.instance.ref(
      "users/$uid/workEntries",
    );

    return StreamBuilder<DatabaseEvent>(
      stream: workRef.onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          // EMPTY STATE
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.assignment_outlined,
                  size: 100,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                const Text(
                  "You haven't submitted any work yet.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Start by adding your first work entry.",
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Add Work Entry",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddWorkEntryPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        // IF DATA EXISTS → Show Work History
        return WorkEntriesPage(uid: uid);
      },
    );
  }
}