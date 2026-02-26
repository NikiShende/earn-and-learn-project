import 'package:firebase_database/firebase_database.dart';

class DashboardService {
  final DatabaseReference usersRef =
      FirebaseDatabase.instance.ref("users");

  /// 🔹 Total Students
  Stream<int> totalStudents() {
    return usersRef.onValue.map((event) {
      if (event.snapshot.value == null) return 0;

      final users =
          Map<String, dynamic>.from(event.snapshot.value as Map);

      int count = 0;
      users.forEach((_, user) {
        if (user['role'] == 'Student') count++;
      });
      return count;
    });
  }

  /// 🔹 Total Approved Hours (All Students)
  Stream<double> approvedHours() {
    return usersRef.onValue.map((event) {
      if (event.snapshot.value == null) return 0;

      final users =
          Map<String, dynamic>.from(event.snapshot.value as Map);

      double total = 0;

      users.forEach((_, user) {
        if (user['role'] != 'Student') return;
        if (user['workEntries'] == null) return;

        final works =
            Map<String, dynamic>.from(user['workEntries'] as Map);

        works.forEach((_, entry) {
          final e = Map<String, dynamic>.from(entry as Map);
          if ((e['status'] ?? '').toString().toLowerCase() ==
              'approved') {
            total +=
                double.tryParse("${e['hours'] ?? 0}") ?? 0;
          }
        });
      });

      return total;
    });
  }

  /// 🔹 Monthly Expense
  Stream<double> monthlyExpense() {
    return approvedHours().map((hours) => hours * 55);
  }

  /// 🔹 Students List
  Stream<List<Map<String, dynamic>>> studentsList() {
    return usersRef.onValue.map((event) {
      if (event.snapshot.value == null) return [];

      final users =
          Map<String, dynamic>.from(event.snapshot.value as Map);

      return users.values
          .where((u) => u['role'] == 'Student')
          .map((u) => Map<String, dynamic>.from(u))
          .toList();
    });
  }

  /// 🔹 Billing Data
  Stream<List<Map<String, dynamic>>> billingData() {
    return usersRef.onValue.map((event) {
      if (event.snapshot.value == null) return [];

      final users =
          Map<String, dynamic>.from(event.snapshot.value as Map);

      List<Map<String, dynamic>> billing = [];

      users.forEach((_, user) {
        if (user['role'] != 'Student') return;
        if (user['workEntries'] == null) return;

        int hours = 0;
        final works =
            Map<String, dynamic>.from(user['workEntries'] as Map);

        works.forEach((_, entry) {
          final e = Map<String, dynamic>.from(entry as Map);
          if ((e['status'] ?? '').toString().toLowerCase() ==
              'approved') {
            hours += int.tryParse("${e['hours'] ?? 0}") ?? 0;
          }
        });

        billing.add({
          "name": user['name'],
          "class": user['class'],
          "department": user['department'],
          "hours": hours,
          "amount": hours * 55,
        });
      });

      return billing;
    });
  }
}
