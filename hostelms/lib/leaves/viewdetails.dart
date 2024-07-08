//warden side full view of leav application after clicking view details
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewLeaveApplicationDetailsPage extends StatefulWidget {
  final String docId;

  ViewLeaveApplicationDetailsPage({required this.docId});

  @override
  _ViewLeaveApplicationDetailsPageState createState() =>
      _ViewLeaveApplicationDetailsPageState();
}

class _ViewLeaveApplicationDetailsPageState
    extends State<ViewLeaveApplicationDetailsPage> {

// class _LeaveApplicationDetailsState extends State<LeaveApplicationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Application Details'),
        backgroundColor: Color(0xFF43328b),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('leaveApplications')
            .doc(widget.docId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Leave application not found.'));
          }

          Map<String, dynamic> leaveData = snapshot.data!.data() as Map<String, dynamic>;
          String uid = leaveData['uid'];

          return FutureBuilder(
            future: FirebaseFirestore.instance.collection('user').doc(uid).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
              if (userSnapshot.hasError) {
                return Text('Error fetching user details');
              }

              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Text('User details not found');
              }

              Map<String, dynamic> userData = userSnapshot.data!.data() as Map<String, dynamic>;
              String fullName = userData['full_name'] ?? 'Unknown';
              String phoneno = userData['contact_number'] ?? 'null';


              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('hosteliteDetails').doc(uid).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> hosteliteSnapshot) {
                  if (hosteliteSnapshot.hasError) {
                    return Text('Error fetching hostelite details');
                  }

                  if (hosteliteSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!hosteliteSnapshot.hasData || !hosteliteSnapshot.data!.exists) {
                    return Text('Hostelite details not found');
                  }

                  Map<String, dynamic> hosteliteData = hosteliteSnapshot.data!.data() as Map<String, dynamic>;
                  String roomNumber = hosteliteData['room_number'] ?? 'Not assigned';
                  String parentPhone = hosteliteData['parent_phone_number'] ?? 'Not available';
                  String course = hosteliteData['course'] ?? 'Not specified';

                  return Center(
                    child: Card(
                      color: Color(0xFF43328b), // Purple color for the card
                      margin: EdgeInsets.all(16.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name: ${(fullName).toUpperCase()}',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                                Text(
                                  DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(leaveData['timestamp'].millisecondsSinceEpoch)),
                                  style: TextStyle(color: Colors.white, fontSize: 13),
                                ),
                              ],
                            ),
                            SizedBox(height: 8,),
                           
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Course: $course',
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                                Text(
                                  DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(leaveData['timestamp'].millisecondsSinceEpoch)),
                                  style: TextStyle(color: Colors.white, fontSize: 13),
                                ),
                              ],
                            ),
                               
                            SizedBox(height: 8.0),
                            Text('Semester: ${leaveData['semester']}', style: TextStyle(color: Colors.white, fontSize: 15)),
                            SizedBox(height: 8.0),
                            Text('Hostel: ${userData['allocated_hostel'] ?? 'Not allocated'}', style: TextStyle(color: Colors.white, fontSize: 15)),
                            SizedBox(height: 8.0),
                            Text('Room Number: $roomNumber', style: TextStyle(color: Colors.white, fontSize: 15)),
                            SizedBox(height: 8.0),
                            Text('From: ${leaveData['fromDate']} To: ${leaveData['toDate']}', style: TextStyle(color: Colors.white, fontSize: 15)),
                            SizedBox(height: 8.0),
                            Text('Reason: ${leaveData['reason']}', style: TextStyle(color: Colors.white, fontSize: 15)),
                            SizedBox(height: 8.0),
                            Text('Student Phone: $phoneno', style: TextStyle(color: Colors.white, fontSize: 15)),
                            SizedBox(height: 8.0),
                            Text('Parent Phone: $parentPhone', style: TextStyle(color: Colors.white, fontSize: 15)),
                            SizedBox(height: 8.0),
                            Text('Parent Approval: ${leaveData['parentApproval'] ? 'Yes' : 'No'}', style: TextStyle(color: Colors.white, fontSize: 15)),
                            SizedBox(height: 8.0),
                            Text('Emergency Phone: ${leaveData['emergencyPhone']}', style: TextStyle(color: Colors.white, fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
