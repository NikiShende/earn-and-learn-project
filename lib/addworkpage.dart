// import 'package:elms/fetchworkentries.dart' as prefix0;
import 'fetchworkentries.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'work_entry.dart';

class AddWorkEntryPage extends StatefulWidget {
  final WorkEntry? workToEdit; // optional for adding or editing

  const AddWorkEntryPage({super.key, this.workToEdit});

  @override
  State<AddWorkEntryPage> createState() => _AddWorkEntryPageState();
}

class _AddWorkEntryPageState extends State<AddWorkEntryPage> {
   late TextEditingController titleController;
  late TextEditingController workplaceController;
  late TextEditingController dateController;
  late TextEditingController fromController;
  late TextEditingController toController;
  late TextEditingController hoursController;
  late TextEditingController statusController;
  late TextEditingController descriptionController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    final work = widget.workToEdit;

    titleController = TextEditingController(text: work?.title ?? '');
    workplaceController = TextEditingController(text: work?.workplace ?? '');
    dateController = TextEditingController(text: work?.date ?? '');
    fromController = TextEditingController(text: work?.fromTime ?? '');
    toController = TextEditingController(text: work?.toTime ?? '');
    hoursController = TextEditingController(text: work?.hours ?? '');
    statusController = TextEditingController(text: work?.status ?? 'Pending');
    descriptionController = TextEditingController(text: work?.description ?? '');
    
    _titleController.text = work?.title ?? '';
    _descriptionController.text = work?.description ?? '';
    _selectedWorkplace = work?.workplace;
    
    if (work != null) {
      _selectedDate = _parseDate(work.date);
      _fromTime = _parseTime(work.fromTime);
      _toTime = _parseTime(work.toTime);
    }
  }
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _fromTime = TimeOfDay.now();
  TimeOfDay _toTime = TimeOfDay.now();

  // 🔹 Workplace options
  final List<String> workplaces = [
    "Computer",
    "Mechanical",
    "Civil",
    "ETC",
    "ECE",
    "IT",
    "Chemical",
    "Library",
    "Hostel",
    "A & R",
    "AIDS",
    "Instrumentation",
    "Library",
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
   "AICTE IDEA Lab",
   
  ];

  String? _selectedWorkplace;

  @override
  void dispose() {
    titleController.dispose();
    workplaceController.dispose();
    dateController.dispose();
    fromController.dispose();
    toController.dispose();
    hoursController.dispose();
    statusController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  void _saveWork() {
    final work = WorkEntry(
      key: widget.workToEdit?.key ?? '',
      id: widget.workToEdit?.id ?? '',
      title: titleController.text,
      workplace: workplaceController.text,
      date: dateController.text,
      fromTime: fromController.text,
      toTime: toController.text,
      hours: hoursController.text,
      status: statusController.text,
      description: descriptionController.text,
    );

    Navigator.pop(context, work);
  }
  // 📅 Date formatter
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} "
        "${_getMonthName(date.month)} ${date.year}";
  }

  String _getMonthName(int month) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec',
    ];
    return months[month - 1];
  }

  // ⏰ Time formatter
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // 🧮 Calculate hours
  int _calculateHours() {
    final fromMinutes = _fromTime.hour * 60 + _fromTime.minute;
    final toMinutes = _toTime.hour * 60 + _toTime.minute;
    return ((toMinutes - fromMinutes) / 60).round();
  }

  // Parse date string back to DateTime
  DateTime _parseDate(String dateStr) {
    try {
      final parts = dateStr.split(' ');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final monthName = parts[1];
        final year = int.parse(parts[2]);
        final monthIndex = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'].indexOf(monthName) + 1;
        return DateTime(year, monthIndex, day);
      }
    } catch (e) {
      // If parsing fails, return current date
    }
    return DateTime.now();
  }

  // Parse time string back to TimeOfDay
  TimeOfDay _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(' ');
      if (parts.length == 2) {
        final timePart = parts[0].split(':');
        final hour = int.parse(timePart[0]);
        final minute = int.parse(timePart[1]);
        final isPM = parts[1] == 'PM';
        final hour24 = isPM && hour != 12 ? hour + 12 : (hour == 12 && !isPM ? 0 : hour);
        return TimeOfDay(hour: hour24, minute: minute);
      }
    } catch (e) {
      // If parsing fails, return current time
    }
    return TimeOfDay.now();
  }
Future<void> _saveWorkEntry() async {
  if (!_formKey.currentState!.validate() || _isLoading) return;

  setState(() => _isLoading = true);

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User not logged in")),
    );
    setState(() => _isLoading = false);
    return;
  }

  try {
    final DatabaseReference workRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user.uid)
        .child('workEntries');

    final workData = {
      "title": _titleController.text,
      "workplace": _selectedWorkplace!,
      "date": _formatDate(_selectedDate),
      "fromTime": _formatTime(_fromTime),
      "toTime": _formatTime(_toTime),
      "hours": _calculateHours().toString(),
      "description": _descriptionController.text,

      /// ✅ IMPORTANT
      /// keep old status when editing
      "status": widget.workToEdit?.status ?? "Pending",
    };

    /// =============================
    /// ✏️ EDIT MODE
    /// =============================
    if (widget.workToEdit != null) {
      await workRef
          .child(widget.workToEdit!.key)
          .update(workData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Work entry updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    /// =============================
    /// ➕ ADD MODE
    /// =============================
    else {
      await workRef.push().set(workData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Work entry added successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    if (mounted) Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1E3D),
        foregroundColor: Colors.white,
        title: Text(widget.workToEdit != null ? 'Edit Work Entry' : 'Add Work Entry'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      /// 🧾 Work Title
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Work Title',
                          prefixIcon: const Icon(Icons.work_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter work title'
                                : null,
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 Workplace Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedWorkplace,
                        items: workplaces.map((workplace) {
                          return DropdownMenuItem(
                            value: workplace,
                            child: Text(workplace),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedWorkplace = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Workplace',
                          prefixIcon: const Icon(Icons.apartment),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Please select workplace'
                                : null,
                      ),

                      const SizedBox(height: 20),

                      /// 📅 Date Picker
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            setState(() => _selectedDate = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(_formatDate(_selectedDate)),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ⏰ Time Pickers
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: _fromTime,
                                );
                                if (time != null) {
                                  setState(() => _fromTime = time);
                                }
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'From Time',
                                  prefixIcon: const Icon(Icons.access_time),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(_formatTime(_fromTime)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: _toTime,
                                );
                                if (time != null) {
                                  setState(() => _toTime = time);
                                }
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'To Time',
                                  prefixIcon:
                                      const Icon(Icons.access_time_filled),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(_formatTime(_toTime)),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// 📝 Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter description'
                                : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// ➕ Add Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _isLoading ? null : _saveWorkEntry,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          widget.workToEdit != null ? 'Update Work Entry' : 'Add Work Entry',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
