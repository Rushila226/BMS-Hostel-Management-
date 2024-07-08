//warden side just overview of leave application
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostelms/leaves/viewdetails.dart';

class WardenLeaveApplicationsPage extends StatefulWidget {
  @override
  _WardenLeaveApplicationsPageState createState() => _WardenLeaveApplicationsPageState();
}

class _WardenLeaveApplicationsPageState extends State<WardenLeaveApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Applications'),
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
        ),child:StreamBuilder(
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
              String uid = data['uid'];

              // Fetch user details based on uid
              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('user').doc(uid).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.hasError) {
                    return Text('Error fetching user details');
                  }

                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return Text('User details not found');
                  }

                  Map<String, dynamic> userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  String fullName = userData['full_name'] ?? 'Unknown';

             
                  return Card(
  margin: EdgeInsets.symmetric(vertical: 8.0),
  color: Color(0xFF43328b), // The specified background color
  child: ListTile(
    title: Text(
      'Leave Application from ${fullName.toUpperCase()}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dates: ${data['fromDate']} to ${data['toDate']}',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        Text(
          'Reason: ${data['reason']}',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20,),
        TextButton(
          
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewLeaveApplicationDetailsPage(docId: doc.id)),
            );
          },
           style: TextButton.styleFrom(
            backgroundColor: Colors.white, // Text color
          ),
          child: Text(
            'View Details',
            style: TextStyle(
              color: Color(0xFF43328b) // Purple text color
            ),
          ),
        ),
      ],
    ),
  ),
);

                },
              );
            }).toList(),
          );
        },
        ),
      ),
    );
  }
}

