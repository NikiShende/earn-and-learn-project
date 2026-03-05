import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class StudentDetailPage extends StatefulWidget {
  final String studentUid;
  final String studentName;

  const StudentDetailPage({
    super.key,
    required this.studentUid,
    required this.studentName,
  });

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage>
    with SingleTickerProviderStateMixin {
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> studentWorks = [];
  bool isLoading = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _fetchStudentWorks();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  }

  void _fetchStudentWorks() {
    _userRef
        .child("users")
        .child(widget.studentUid)
        .child("workEntries")
        .onValue
        .listen((event) {
      final List<Map<String, dynamic>> list = [];
      if (event.snapshot.value != null) {
        final workEntries = Map<String, dynamic>.from(event.snapshot.value as Map);
     workEntries.forEach((id, workRaw) {
  final work = Map<String, dynamic>.from(workRaw);

  final status =
      (work["status"] ?? "").toString().toLowerCase();

  // ✅ SHOW ONLY APPROVED BY SUB
  if (status == "approved_by_sub" || status == "verified_by_hod"|| status == "rejected")  {
    list.add({
      "workId": id,
      "title": work["title"],
      "description": work["description"],
      "status": status,
      "hours": work["hours"],
      "fromTime": work["fromTime"],
      "toTime": work["toTime"],
      "workplace": work["workplace"],
      "date": work["date"],
    });
  }
});
      }
      setState(() {
        studentWorks = list;
        isLoading = false;
        _animationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved_by_sub':
    case 'verified_by_hod':
      return Colors.green;
     
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Widget _statusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
            color: color, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),
      appBar: AppBar(
        title: Text(widget.studentName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF0B1E3D),
        elevation: 1,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : studentWorks.isEmpty
              ? const Center(
                  child: Text(
                    "No approved work entries found",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: studentWorks.length,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemBuilder: (context, index) {
                    final w = studentWorks[index];
                    final status = w["status"] ?? "approved_by_sub";

                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final slide = Tween<Offset>(
                                begin: const Offset(1, 0), end: Offset.zero)
                            .animate(
                          CurvedAnimation(
                              parent: _animationController,
                              curve: Interval((index / studentWorks.length), 1.0,
                                  curve: Curves.easeOut)),
                        );
                        return SlideTransition(position: slide, child: child);
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    w["title"] ?? '-',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                _statusBadge(status),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 16, color: Colors.black54),
                                const SizedBox(width: 4),
                                Text(
                                  "${w["hours"] ?? 0} hrs",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.location_on,
                                    size: 16, color: Colors.black54),
                                const SizedBox(width: 4),
                                Text(
                                  w["workplace"] ?? '-',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              w["description"] ?? '-',
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 14, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
