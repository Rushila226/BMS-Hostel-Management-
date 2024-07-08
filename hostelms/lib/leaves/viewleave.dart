//hostel side viewing leave applications
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewLeaveApplicationsPage extends StatefulWidget {
  @override
  _ViewLeaveApplicationsPageState createState() => _ViewLeaveApplicationsPageState();
}

class _ViewLeaveApplicationsPageState extends State<ViewLeaveApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Leave Applications'),
                backgroundColor: Color(0xFF43328b),
        foregroundColor:Colors.white ,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('leaveApplications').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No leave applications found.'));
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              DateTime submittedDateTime = DateTime.fromMillisecondsSinceEpoch(data['timestamp'].millisecondsSinceEpoch);
              String formattedDate = DateFormat('yyyy-MM-dd').format(submittedDateTime);
              String formattedTime = DateFormat('HH:mm:ss').format(submittedDateTime);
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                color: Color(0xFF43328b),
                child: ListTile(
                  title:  RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 17),
                          children: [
                            TextSpan(
                              text: 'Semester: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '${data['semester']}'),
                          ],
                        ),
                      ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          children: [
                            TextSpan(
                              text: 'Reason: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '${data['reason']}'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          children: [
                            TextSpan(
                              text: 'From: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '${data['fromDate']} '),
                            TextSpan(
                              text: 'To: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '${data['toDate']}'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          children: [
                            TextSpan(
                              text: 'Emergency Phone: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '${data['emergencyPhone']}'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          children: [
                            TextSpan(
                              text: 'Parent Approval: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '${data['parentApproval'] ? 'Yes' : 'No'}'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          children: [
                            TextSpan(
                              text: 'Submitted Date: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '$formattedDate'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          children: [
                            TextSpan(
                              text: 'Submitted Time: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '$formattedTime'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
