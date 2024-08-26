
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostelms/pages/employee.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//first page of announcements
class Home extends StatefulWidget {
  final String userType;

  const Home({Key? key, required this.userType}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String currentUserId;
    // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    //  setupFCM();
  }

  void getCurrentUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    } else {
      // Handle user not signed in scenario
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.userType == 'warden'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Employee()),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
      appBar: AppBar(
        title: Text('Announcements'),
        // shadowColor: const Color.fromARGB(255, 158, 117, 166),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              const Color.fromARGB(255, 117, 80, 182),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('files')
              .orderBy('uploadedAt', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final DateTime uploadedAt = (doc['uploadedAt'] as Timestamp?)?.toDate() ?? DateTime.now();
                final List<dynamic> fileUrls = doc['fileUrls'] ?? [];
                final List<dynamic> fileNames = doc['fileNames'] ?? [];
                final String uploadedByUid = doc['uploadedBy'] ?? '';
                final String message = doc['message'] ?? '';

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('user').doc(uploadedByUid).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (userSnapshot.hasError) {
                      return Center(child: Text('Error: ${userSnapshot.error}'));
                    }
                    if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                      return Center(child: Text('User not found'));
                    }

                    final String uploadedByName = (userSnapshot.data?['full_name'] as String?)?.toUpperCase() ?? 'Unknown User';

                    return Card(
                      margin: EdgeInsets.all(12),
                      color: Color.fromARGB(255, 238, 234, 234),
                      child: ListTile(
                        // leading: Icon(Icons.insert_drive_file),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person, size: 16),
                                    SizedBox(width: 4),
                                    Text('$uploadedByName'),
                                  ],
                                ),
                                if (widget.userType == 'warden')
                                  IconButton(
                                    icon: Icon(Icons.delete, size: 20, color: Colors.red),
                                    onPressed: () async {
                                      await deleteAnnouncement(doc.id);
                                    },
                                  ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16),
                                SizedBox(width: 4),
                                Text('Date: ${DateFormat.yMMMd().format(uploadedAt)}'),
                                SizedBox(width: 8),
                                Icon(Icons.access_time, size: 16),
                                SizedBox(width: 4),
                                Text('Time: ${DateFormat.Hm().format(uploadedAt)}'),
                              ],
                            ),
                            if (message.isNotEmpty) ...[
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.message, size: 16),
                                  SizedBox(width: 4),
                                  Text('Message: $message'),
                                ],
                              ),
                            ],
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            for (int i = 0; i < fileUrls.length; i++)
                              Row(
                                children: [
                                  Icon(Icons.file_present, size: 16),
                                  SizedBox(width: 4),
                                  TextButton(
                                    onPressed: () {
                                      openFile(fileUrls[i]);
                                    },
                                    child: Text('${fileNames[i] ?? 'Unknown File'}'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> deleteAnnouncement(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('files').doc(docId).delete();
      // Show a snackbar or toast to indicate the deletion was successful
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Announcement deleted successfully')));
    } catch (e) {
      print('Error deleting announcement: $e');
      // Show a snackbar or toast to indicate the deletion failed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting announcement')));
    }
  }

  Future<void> openFile(String fileUrl) async {
    try {
      // Get temporary directory
      final dir = await getTemporaryDirectory();
      // Create a file in the temporary directory
      final file = File('${dir.path}/${fileUrl.split('/').last}');
      // Download the file from Firebase Storage
      final ref = firebase_storage.FirebaseStorage.instance.refFromURL(fileUrl);
      await ref.writeToFile(file);

      // Open the file
      await OpenFile.open(file.path);
    } catch (e) {
      print('Error opening file: $e');
    }
  }
}
