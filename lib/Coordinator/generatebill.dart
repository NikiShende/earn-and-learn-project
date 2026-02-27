// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart'; // add in pubspec.yaml
// import 'package:intl/intl.dart';

// class MonthlyBillPage extends StatefulWidget {
//   final String uid;
//   const MonthlyBillPage({super.key, required this.uid});

//   @override
//   State<MonthlyBillPage> createState() => _MonthlyBillPageState();
// }

// class _MonthlyBillPageState extends State<MonthlyBillPage> {
//   DateTime selectedMonth = DateTime.now();

//   /// Rate per hour
//   static const double ratePerHour = 55;

//   /// Fetch weekly hours for the selected month
// Future<Map<int, double>> fetchWeeklyHours() async {
//   final ref =
//       FirebaseDatabase.instance.ref('users/${widget.uid}/workEntries');
//   final snapshot = await ref.get();

//   Map<int, double> weeklyHours = {};
//   if (!snapshot.exists || snapshot.value == null) return weeklyHours;

//   if (snapshot.value is! Map) return weeklyHours;
//   final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

//   for (var workEntry in data.values) {
//     if (workEntry is! Map) continue;

//     final work = Map<String, dynamic>.from(workEntry);
//     final status = work['status']?.toString().toLowerCase();
//     final hours =
//         double.tryParse(work['hours']?.toString() ?? '0') ?? 0;
//     final dateStr = work['date']?.toString() ?? '';

//     DateTime? date;
//     try {
//       date = DateFormat('dd MMM yyyy').parse(dateStr);
//     } catch (_) {
//       date = null;
//     }

//     if (status == 'approved' && date != null) {
//       if (date.month == selectedMonth.month &&
//           date.year == selectedMonth.year) {
//         int weekOfMonth = ((date.day - 1) ~/ 7) + 1;
//         weeklyHours[weekOfMonth] =
//             (weeklyHours[weekOfMonth] ?? 0) + hours;
//       }
//     }
//   }

//   return weeklyHours;
// }
// Future<Map<String, dynamic>> fetchStudentDetails() async {
//   final ref = FirebaseDatabase.instance.ref('users/${widget.uid}');
//   final snapshot = await ref.get();

//   if (!snapshot.exists || snapshot.value == null) return {};

//   return Map<String, dynamic>.from(snapshot.value as Map);
// }

//   /// Helper for row
//   Widget detailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 140,
//             child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//           ),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }

//   /// Month picker
//   void _pickMonth() async {
//     final picked = await showMonthPicker(
//       context: context,
//       initialDate: selectedMonth,
//     );
//     if (picked != null) {
//       setState(() {
//         selectedMonth = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Generate Monthly Bill"),
//         backgroundColor: Colors.blue.shade700,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Month Selector
//             ElevatedButton.icon(
//               onPressed: _pickMonth,
//               icon: const Icon(Icons.calendar_today),
//               label: Text("Select Month: ${selectedMonth.month}-${selectedMonth.year}"),
//             ),
//             const SizedBox(height: 16),

//             // Billing Card
//             Expanded(
//               child: FutureBuilder<Map<int, double>>(
//                 future: fetchWeeklyHours(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasError) {
//                     return Center(child: Text("Error: ${snapshot.error}"));
//                   }

//                   final weeklyHours = snapshot.data!;
//                   double totalAmount = weeklyHours.values.fold(0, (sum, h) => sum + h * ratePerHour);

//                   return Card(
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: ListView(
//                         children: [
//                           Text(
//                             "Billing for ${selectedMonth.month}-${selectedMonth.year}",
//                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                           ),
//                           const SizedBox(height: 12),
//                           ...weeklyHours.entries.map((e) {
//                             final amount = e.value * ratePerHour;
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 detailRow("Week ${e.key} Hours", e.value.toStringAsFixed(2)),
//                                 detailRow("Week ${e.key} Amount", "₹${amount.toStringAsFixed(2)}"),
//                                 const SizedBox(height: 8),
//                               ],
//                             );
//                           }).toList(),
//                           const Divider(),
//                           detailRow("Total Amount", "₹${totalAmount.toStringAsFixed(2)}"),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class MonthlyBillPage extends StatefulWidget {
  final String uid;
  const MonthlyBillPage({super.key, required this.uid});

  @override
  State<MonthlyBillPage> createState() => _MonthlyBillPageState();
}

class _MonthlyBillPageState extends State<MonthlyBillPage> {
  DateTime selectedMonth = DateTime.now();
double? editedTotalHours;
double? editedTotalAmount;

  static const double ratePerHour = 55;

  /// 🔹 Fetch Student Details
  Future<Map<String, dynamic>> fetchStudentDetails() async {
    final ref = FirebaseDatabase.instance.ref('users/${widget.uid}');
    final snapshot = await ref.get();

    if (!snapshot.exists || snapshot.value == null) return {};
    return Map<String, dynamic>.from(snapshot.value as Map);
  }

  /// 🔹 Fetch Weekly Approved Hours
  Future<Map<int, double>> fetchWeeklyHours() async {
    final ref = FirebaseDatabase.instance.ref(
      'users/${widget.uid}/workEntries',
    );
    final snapshot = await ref.get();

    Map<int, double> weeklyHours = {};
    if (!snapshot.exists || snapshot.value == null) return weeklyHours;

    if (snapshot.value is! Map) return weeklyHours;
    final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

    for (var workEntry in data.values) {
      if (workEntry is! Map) continue;

      final work = Map<String, dynamic>.from(workEntry);
      final status = work['status']?.toString().toLowerCase();
      final hours = double.tryParse(work['hours']?.toString() ?? '0') ?? 0;
      final dateStr = work['date']?.toString() ?? '';

      DateTime? date;
      try {
        date = DateFormat('dd MMM yyyy').parse(dateStr);
      } catch (_) {
        date = null;
      }

      if (( status == 'approved_by_sub') &&
    date != null) {
        if (date.month == selectedMonth.month &&
            date.year == selectedMonth.year) {
          int weekOfMonth = ((date.day - 1) ~/ 7) + 1;
          weeklyHours[weekOfMonth] = (weeklyHours[weekOfMonth] ?? 0) + hours;
        }
      }
    }

    return weeklyHours;
  }
  void _editTotals(double hours, double amount) {
  final hoursCtrl =
      TextEditingController(text: hours.toStringAsFixed(1));

  final amountCtrl = TextEditingController(
      text: (hours * ratePerHour).toStringAsFixed(2));

  /// AUTO CALCULATE AMOUNT
  hoursCtrl.addListener(() {
    final newHours =
        double.tryParse(hoursCtrl.text) ?? 0;

    final newAmount = newHours * ratePerHour;

    amountCtrl.text = newAmount.toStringAsFixed(2);
  });

  showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF5F7FA)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// HEADER
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade600,
                      Colors.blue.shade800
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Edit Total Hours",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// HOURS FIELD (Editable)
              TextField(
                controller: hoursCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.access_time),
                  labelText: "Total Hours",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// AMOUNT FIELD (READ ONLY)
              TextField(
                controller: amountCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.currency_rupee),
                  labelText: "Total Amount (Auto)",
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          editedTotalHours =
                              double.tryParse(
                                      hoursCtrl.text) ??
                                  hours;

                          editedTotalAmount =
                              editedTotalHours! *
                                  ratePerHour;
                        });

                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Update",
                        style:
                            TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}



  /// 🔹 Reusable Row
  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// 🔹 Month Picker
  void _pickMonth() async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: selectedMonth,
    );
    if (picked != null) {
      setState(() => selectedMonth = picked);
    }
  }

  /// 🔹 Generate PDF
Future<void> generatePdf(
  Map<String, dynamic> student,
  Map<int, double> weeklyHours,
  double totalHours,
  double totalAmount,
) async {
  final pdf = pw.Document();

  final fontData =
      await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
  final ttf = pw.Font.ttf(fontData);

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                "MONTHLY WORK BILL",
                style: pw.TextStyle(
                  font: ttf, // 👈 IMPORTANT
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Divider(),

            pw.Text(
              "Student Details",
              style: pw.TextStyle(
                font: ttf,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),

            pw.Text("Name: ${student['name'] ?? 'N/A'}",
                style: pw.TextStyle(font: ttf)),

            pw.Text("Department: ${student['actualDepartment'] ?? 'N/A'}",
                style: pw.TextStyle(font: ttf)),

            pw.Text("Email: ${student['email'] ?? 'N/A'}",
                style: pw.TextStyle(font: ttf)),
            pw.Text(
              "Month: ${DateFormat('MMMM yyyy').format(selectedMonth)}",
              style: pw.TextStyle(font: ttf),
            ),

            pw.Divider(),

            pw.Text(
              "Weekly Work Summary",
              style: pw.TextStyle(
                font: ttf,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 6),

            ...weeklyHours.entries.map((e) {
              final amount = e.value * ratePerHour;
              return pw.Text(
                "Week ${e.key}: ${e.value.toStringAsFixed(2)} hrs × ₹$ratePerHour = ₹${amount.toStringAsFixed(2)}",
                style: pw.TextStyle(font: ttf), // 👈 IMPORTANT
              );
            }),

            pw.Divider(),

            pw.Text(
              "Total Hours: ${totalHours.toStringAsFixed(2)}",
              style: pw.TextStyle(font: ttf),
            ),

            pw.Text(
              "Total Amount: ₹${totalAmount.toStringAsFixed(2)}",
              style: pw.TextStyle(
                font: ttf,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              "Generated On: ${DateTime.now()}",
              style: pw.TextStyle(font: ttf),
            ),

            pw.SizedBox(height: 30),

            pw.Text(
              "Authorized Signature",
              style: pw.TextStyle(font: ttf),
            ),
          ],
        );
      },
    ),
  );

  final pdfBytes = await pdf.save();

  await Printing.sharePdf(
    bytes: pdfBytes,
    filename:
        'Monthly_Bill_${DateFormat('MMMM_yyyy').format(selectedMonth)}_${student['name']}.pdf',
  );
}

  /// 🔹 Save Bill to Firebase
  Future<void> saveBillToFirebase(
    Map<String, dynamic> student,
    Map<int, double> weeklyHours,
    double totalHours,
    double totalAmount,
  ) async {
    final monthKey = "${selectedMonth.year}-${selectedMonth.month}";

    await FirebaseDatabase.instance.ref('bills/${widget.uid}/$monthKey').set({
      'studentName': student['name'],
      'department': student['actualDepartment'],
      'ratePerHour': ratePerHour,
      'totalHours': totalHours,
      'totalAmount': totalAmount,
      'weeklyHours': weeklyHours,
      'generatedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E121F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E121F),
        foregroundColor: Colors.white,
        title: const Text("Generate Monthly Bill", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0E121F), Color(0xFF1A1F2E)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Month Selector Card
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.blue, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Select Month",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('MMMM yyyy').format(selectedMonth),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _pickMonth,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Change", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Bill Details
              Expanded(
                child: FutureBuilder(
                  future: Future.wait([
                    fetchStudentDetails(),
                    fetchWeeklyHours(),
                  ]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    final student = snapshot.data![0] as Map<String, dynamic>;
                    final weeklyHours = snapshot.data![1] as Map<int, double>;

                    final totalHours = weeklyHours.values.fold(0.0, (a, b) => a + b);
                    final totalAmount = totalHours * ratePerHour;

                    return Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey.shade50],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListView(
                            children: [
                              // Header
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.blue.shade600, Colors.blue.shade800],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    "MONTHLY WORK BILL",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Student Details Section
                              _buildSection(
                                "Student Information",
                                Icons.person,
                                [
                                  detailRow("Name", student['name'] ?? 'N/A'),
                                  detailRow("Department", student['actualDepartment'] ?? 'N/A'),
                                  detailRow("Email", student['email'] ?? 'N/A'),
                                  detailRow("Class", student['class'] ?? 'N/A'),
                                   const Divider(),

                                    detailRow(
                                        "Account Holder",
                                        student['accountHolderName'] ?? 'N/A'),

                                    detailRow(
                                        "Account Number",
                                        student['accountNumber'] ?? 'N/A'),

                                    detailRow(
                                        "IFSC Code",
                                        student['ifscCode'] ?? 'N/A')
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Work Summary Section
                              _buildSection(
                                "Work Summary - ${DateFormat('MMMM yyyy').format(selectedMonth)}",
                                Icons.work,
                                [
                                  ...weeklyHours.entries.map((e) {
                                    final amount = e.value * ratePerHour;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.blue.shade200),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Week ${e.key}",
                                            style: const TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "${e.value.toStringAsFixed(1)} hrs × ₹$ratePerHour = ₹${amount.toStringAsFixed(2)}",
                                            style: TextStyle(color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Total Section
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.green.shade100, Colors.green.shade50],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.green.shade300),
                                ),
                                child: Column(
                                  children: [
   Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      "Total Hours:",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    Row(
      children: [
        Text(
          "${(editedTotalHours ?? totalHours).toStringAsFixed(1)} hrs",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.edit, size: 18),
          onPressed: () => _editTotals(
              editedTotalHours ?? totalHours,
              editedTotalAmount ?? totalAmount),
        ),
      ],
    ),
  ],
),


                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Total Amount:",
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                        ),
                                       Text(
  "₹${(editedTotalAmount ?? totalAmount).toStringAsFixed(2)}",
  style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.green),
),

                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Generate PDF Button
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.orange.shade400, Colors.orange.shade600],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                                  label: const Text(
                                    "Generate PDF & Save Bill",
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                  ),
                                  onPressed: () async {
                                   final finalHours = editedTotalHours ?? totalHours;
final finalAmount = editedTotalAmount ?? totalAmount;

await generatePdf(student, weeklyHours, finalHours, finalAmount);

await saveBillToFirebase(
    student, weeklyHours, finalHours, finalAmount);

                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
