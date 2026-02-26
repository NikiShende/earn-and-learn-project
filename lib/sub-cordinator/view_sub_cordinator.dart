import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'add_sub_cordinator.dart';

class ViewSubCoordinatorPage extends StatefulWidget {
  const ViewSubCoordinatorPage({super.key});

  @override
  State<ViewSubCoordinatorPage> createState() =>
      _ViewSubCoordinatorPageState();
}

class _ViewSubCoordinatorPageState
    extends State<ViewSubCoordinatorPage> {

  final DatabaseReference subRef =
      FirebaseDatabase.instance.ref().child('sub_coordinators');

  List<Map<String, dynamic>> subCoordinators = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubCoordinators();
  }

  /// ✅ FETCH DATA
  void fetchSubCoordinators() {
    setState(() => isLoading = true);

    subRef.onValue.listen((event) {
      final data =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final tempList = data.entries.map((e) {
          final m = Map<String, dynamic>.from(e.value);
          m['id'] = e.key;
          return m;
        }).toList();

        setState(() {
          subCoordinators = tempList;
          isLoading = false;
        });
      } else {
        setState(() {
          subCoordinators = [];
          isLoading = false;
        });
      }
    });
  }

  /// ✅ DELETE
  void deleteSubCoordinator(String id) {
    subRef.child(id).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),

      appBar: AppBar(
        title: const Text("Sub-Coordinator Management"),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF0B1E3D),
      ),

      /// ➕ ADD BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.person_add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddSubCoordinatorPage(),
            ),
          );
        },
      ),

      /// BODY
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : subCoordinators.isEmpty
              ? const Center(
                  child: Text(
                    "No Sub-Coordinators found",
                    style:
                        TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: subCoordinators.length,
                  itemBuilder: (context, index) {
                    final sub = subCoordinators[index];

                    return Card(
                      elevation: 6,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin:
                          const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Colors.deepPurple.shade100,
                          child: const Icon(
                            Icons.supervisor_account,
                            color: Colors.deepPurple,
                          ),
                        ),

                        /// NAME
                        title: Text(
                          sub['name'] ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),

                        /// DETAILS
                        subtitle: Text(
                          "Dept: ${sub['department'] ?? ''}\n"
                          "Email: ${sub['email'] ?? ''}",
                        ),
                        isThreeLine: true,

                        /// ACTIONS
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            /// ✏ EDIT
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AddSubCoordinatorPage(
                                      subData: sub,
                                      subId: sub['id'],
                                    ),
                                  ),
                                );
                              },
                            ),

                            /// 🗑 DELETE
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text(
                                        "Delete Sub-Coordinator"),
                                    content: const Text(
                                        "Are you sure you want to delete this Sub-Coordinator?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child:
                                            const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteSubCoordinator(
                                              sub['id']);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
