// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'addhod.dart'; // The AddHodPage we designed earlier

// class HodManagementPage extends StatefulWidget {
//   const HodManagementPage({super.key});

//   @override
//   State<HodManagementPage> createState() => _HodManagementPageState();
// }

// class _HodManagementPageState extends State<HodManagementPage> {
//   final DatabaseReference hodRef = FirebaseDatabase.instance.ref().child('hods');

//   List<Map<String, dynamic>> hods = [];
// bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchHods();
//   }

//   void fetchHods() {
//     hodRef.onValue.listen((event) {
//       final data = event.snapshot.value as Map<dynamic, dynamic>?;
//  setState(() {
//     isLoading = true;   // Start loader
//   });
//       if (data != null) {
//         final tempList = data.entries.map((e) {
//           final m = Map<String, dynamic>.from(e.value);
//           m['id'] = e.key; // Save key for editing/deleting if needed
//           return m;
//         }).toList();

//         setState(() {
          
//           hods = tempList;
//            isLoading = false; 
//         });
//       } else {
//         setState(() => hods = []);
//       }
//     });
//   }

//   void deleteHod(String id) {
//     hodRef.child(id).remove();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("HOD Management"),
//         foregroundColor: Colors.white,
//         backgroundColor: const Color(0xFF0B1E3D),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFF0B1E3D),
//         foregroundColor:Colors.white ,
//         child: const Icon(Icons.person_add),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AddHodPage()),
//           );
//         },
//       ),
//       body: hods.isEmpty
//           ? const Center(child: Text("No HODs found"))
//           : ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: hods.length,
//               itemBuilder: (context, index) {
//                 final hod = hods[index];
//                 return Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.purple.shade100,
//                       child: const Icon(Icons.person, color: Colors.purple),
//                     ),
//                     title: Text(
//                       hod['name'],
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text("Dept: ${hod['department']}\nEmail: ${hod['email']}"),
//                     isThreeLine: true,
//                     trailing: Row(
//   mainAxisSize: MainAxisSize.min,
//   children: [

//     /// ✏ EDIT BUTTON
//     IconButton(
//       icon: const Icon(Icons.edit, color: Colors.blue),
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => AddHodPage(
//               hodData: hod,
//               hodId: hod['id'],
//             ),
//           ),
//         );
//       },
//     ),

//     /// 🗑 DELETE BUTTON
//     IconButton(
//       icon: const Icon(Icons.delete, color: Colors.red),
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: const Text("Delete HOD"),
//             content: const Text(
//                 "Are you sure you want to delete this HOD?"),
//             actions: [
//               TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Cancel")),
//               TextButton(
//                   onPressed: () {
//                     deleteHod(hod['id']);
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Delete",
//                       style: TextStyle(color: Colors.red))),
//             ],
//           ),
//         );
//       },
//     ),
//   ],
// ),

//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'addhod.dart';

class HodManagementPage extends StatefulWidget {
  const HodManagementPage({super.key});

  @override
  State<HodManagementPage> createState() => _HodManagementPageState();
}

class _HodManagementPageState extends State<HodManagementPage> {
  final DatabaseReference hodRef =
      FirebaseDatabase.instance.ref().child('hods');

  List<Map<String, dynamic>> hods = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHods();
  }

  void fetchHods() {
    // Start loader only once
    setState(() {
      isLoading = true;
    });

    hodRef.onValue.listen((event) {
      final data =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final tempList = data.entries.map((e) {
          final m =
              Map<String, dynamic>.from(e.value);
          m['id'] = e.key;
          return m;
        }).toList();

        setState(() {
          hods = tempList;
          isLoading = false; // Stop loader
        });
      } else {
        setState(() {
          hods = [];
          isLoading = false; // Stop loader
        });
      }
    });
  }

  void deleteHod(String id) {
    hodRef.child(id).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E3D),
      appBar: AppBar(
        title: const Text("HOD Management"),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF0B1E3D),
      ),
      floatingActionButton: FloatingActionButton(
backgroundColor: Colors.deepPurpleAccent,

        foregroundColor: Colors.white,
        child: const Icon(Icons.person_add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AddHodPage()),
          );
        },
      ),

      // ✅ PROPER LOADER IMPLEMENTATION
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : hods.isEmpty
              ? const Center(
                  child: Text(
                    "No HODs found",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: hods.length,
                  itemBuilder: (context, index) {
                    final hod = hods[index];

                    return Card(
                      elevation: 6,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Colors.purple.shade100,
                          child: const Icon(
                            Icons.person,
                            color: Colors.purple,
                          ),
                        ),
                        title: Text(
                          hod['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Dept: ${hod['department'] ?? ''}\nEmail: ${hod['email'] ?? ''}",
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [

                            /// ✏ EDIT
                            IconButton(
                              icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AddHodPage(
                                      hodData: hod,
                                      hodId:
                                          hod['id'],
                                    ),
                                  ),
                                );
                              },
                            ),

                            /// 🗑 DELETE
                            IconButton(
                              icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      AlertDialog(
                                    title: const Text(
                                        "Delete HOD"),
                                    content: const Text(
                                        "Are you sure you want to delete this HOD?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(
                                                context),
                                        child:
                                            const Text(
                                                "Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteHod(
                                              hod[
                                                  'id']);
                                          Navigator.pop(
                                              context);
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: Colors
                                                  .red),
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
