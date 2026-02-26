// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class StudentExcelExporter {
//   final DatabaseReference studentsRef =
//       FirebaseDatabase.instance.ref("users");

//   Future<String?> exportStudentsToExcel() async {
//     // Request storage permission
//     if (!await Permission.storage.request().isGranted) {
//       return null;
//     }

//     // Create Excel file
//     var excel = Excel.createExcel();
//     Sheet sheet = excel['Students'];

//     // Header Row
//     sheet.appendRow([
//       TextCellValue('Student Name'),
//       TextCellValue('Class'),
//       TextCellValue('Account Holder Name'),
//       TextCellValue('Account Number'),
//       TextCellValue('Working Days'),
//       TextCellValue('Total Amount'),
//       TextCellValue('Department'),
//     ]);

//     // Fetch students from Firebase
//     final snapshot = await studentsRef.get();

//     if (!snapshot.exists) return null;

//     final students = Map<String, dynamic>.from(snapshot.value as Map);

//     for (var student in students.values) {
//       sheet.appendRow([
//         TextCellValue(student['name'] ?? ''),
//         TextCellValue(student['class'] ?? ''),
//         TextCellValue(student['accountHolderName'] ?? ''),
//         TextCellValue(student['accountNumber'] ?? ''),
//         TextCellValue(student['workingDays'] ?? ''),
//         TextCellValue(student['totalAmount'] ?? ''),
//         TextCellValue(student['department'] ?? ''),
//       ]);
//     }

//     // Save file
//     final directory = await getExternalStorageDirectory();
//     final filePath =
//         '${directory!.path}/students_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';

//     final fileBytes = excel.save();
//     final file = File(filePath);
//     await file.writeAsBytes(fileBytes!);

//     return filePath;
//   }
// }



import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class UserExcelExporter {
  final DatabaseReference usersRef =
      FirebaseDatabase.instance.ref("users");

  Future<void> exportUsersToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['Student_Work_Report'];

    final headers = [
  'Student Name',
  'Email',
  'Mobile',
  'Class',
  'Department',
  'Account Holder Name',
  'Account Number',
  'IFSC Code',
  'Approved Hours',
  'Total Amount (₹)',
  'Export Date'
];


    for (int i = 0; i < headers.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = TextCellValue(headers[i]);
    }

    final snapshot = await usersRef.get();
    if (!snapshot.exists) return;

    final users = Map<String, dynamic>.from(snapshot.value as Map);

    int rowIndex = 1;

    for (final entry in users.entries) {
      final user = Map<String, dynamic>.from(entry.value);

      double approvedHours = 0;

      if (user['workEntries'] != null) {
        final workEntries =
            Map<String, dynamic>.from(user['workEntries']);

        for (final workEntry in workEntries.values) {
          final work = Map<String, dynamic>.from(workEntry);

         final status =
    work['status']?.toString().toLowerCase().trim();

if (status == 'approved_by_sub' ||
    status == 'verified_by_hod') {

  final hours =
      double.tryParse(work['hours']?.toString() ?? '0') ?? 0;

  approvedHours += hours;
}
      }
      }

      if (approvedHours == 0) continue;

      final totalAmount = approvedHours * 55;

     final rowData = [
  user['name'] ?? '',
  user['email'] ?? '',
  user['mobile'] ?? '',
  user['class'] ?? '',
  user['actualDepartment'] ?? '',
  user['accountHolderName'] ?? '',
  user['accountNumber'] ?? '',
  user['ifscCode'] ?? '',
  approvedHours.toStringAsFixed(1),
  totalAmount.toStringAsFixed(2),
  DateFormat('dd/MM/yyyy').format(DateTime.now()),
];


      for (int i = 0; i < rowData.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: i, rowIndex: rowIndex))
            .value = TextCellValue(rowData[i]);
      }

      rowIndex++;
    }

    final bytes = excel.encode();
    if (bytes == null) return;

    final fileName =
        "Student_Report_${DateTime.now().millisecondsSinceEpoch}";

    // ✅ Save using file_saver (Downloads like other apps)
    final savedPath = await FileSaver.instance.saveFile(
      name: fileName,
      bytes: Uint8List.fromList(bytes),
      ext: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );

    if (savedPath == null) return;// ✅ ALSO SAVE MANUALLY TO DOWNLOAD FOLDER
final downloadsDir =
    Directory('/storage/emulated/0/Download');

if (!downloadsDir.existsSync()) {
  downloadsDir.createSync(recursive: true);
}


final manualFilePath =
    "${downloadsDir.path}/$fileName.xlsx";

final manualFile = File(manualFilePath);
await manualFile.writeAsBytes(Uint8List.fromList(bytes));

print("Manual Download Path: $manualFilePath");

 
    // ✅ Auto open
    await OpenFile.open(savedPath);
print("Saved path: $savedPath");

    // ✅ Share
    await Share.shareXFiles(
      [XFile(savedPath)],
      text: "Student Work Report",
    );
  }
}
