
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostelms/Login_singup/Services/auth.dart';
import 'package:hostelms/Login_singup/Widget/button.dart';
import 'package:hostelms/Login_singup/loginscreen.dart';
import 'package:hostelms/leaves/leavehostel.dart';
import 'package:hostelms/leaves/wardenleave.dart';
import 'package:hostelms/logsign/screens/login.dart';
import 'package:hostelms/pages/home.dart';
import 'package:hostelms/ticketsystem/ticket.dart';
import 'package:hostelms/ticketsystem/wardenTicketview.dart';

class Homepage extends StatelessWidget {
  final String userType;
  final String userId;

  const Homepage({super.key, required this.userType, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthServices().signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Login(userType: userType),
                ),
              );
            },
          ),
        ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileCard(),
            SizedBox(height: 20),
            _buildNavigationCard('Tickets', Icons.event_available_outlined, Colors.deepPurple, () {
              if (userType == 'hostelite') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Ticket(userId: userId,)));
              } else if (userType == 'warden') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WardenTicketView(userId: userId,)));
              }
            }),
            SizedBox(height: 20),
            _buildNavigationCard('Announcements', Icons.announcement_outlined, Colors.deepPurple, () {
              if (userType == 'hostelite') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home(userType: userType,)));
              } else if (userType == 'warden') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home(userType: userType,)));
              }
            }),
            SizedBox(height: 20),
            _buildNavigationCard('Leave', Icons.mail_lock_outlined, Colors.deepPurple, () {
              if (userType == 'hostelite') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveApplicationForm()));
              } else if (userType == 'warden') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WardenLeaveApplicationsPage()));
              }
            }),
          ],
        ),
      ),
    );
  }
  Widget _buildProfileCard() {
  return Card(
    margin: EdgeInsets.all(20),
    color: Colors.deepPurple,
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.person, color: Colors.white, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                // Display user details based on userType
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('user')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (userSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${userSnapshot.error}'));
                    }

                    if (!userSnapshot.hasData ||
                        userSnapshot.data?.data() == null) {
                      return Center(child: Text('No data available'));
                    }

                    Map<String, dynamic> userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;

                    // Display user details
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FULL NAME: ${userData['full_name'].toString().toUpperCase()}', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),),
                        Text('User Type: $userType', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),),
                        Text('Allocated Hostel: ${userData['allocated_hostel']}', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),),
                        // Fetch room_number from hosteliteDetails
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('hosteliteDetails')
                              .doc(userId)
                              .snapshots(),
                          builder: (context, detailsSnapshot) {
                            if (detailsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (detailsSnapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${detailsSnapshot.error}'));
                            }

                            if (!detailsSnapshot.hasData ||
                                detailsSnapshot.data?.data() == null) {
                              return Center(child: Text(''));
                            }

                            Map<String, dynamic> detailsData =
                                detailsSnapshot.data!.data() as Map<String, dynamic>;

                            // Display room_number if userType is hostelite
                            if (userType == 'hostelite') {
                              return Text('Room Number: ${detailsData['room_number']}', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),);
                            } else {
                              return SizedBox(); // Empty container for wardens
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


 

  Widget _buildNavigationCard(String title, IconData icon, Color color, VoidCallback onPressed) {
    return Card(
      margin: EdgeInsets.all(20),
      color: color,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: GestureDetector(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Icon(icon, color: Colors.white, size: 30), // Placeholder for icon on the right
            ],
          ),
        ),
      ),
    );
  }
}



