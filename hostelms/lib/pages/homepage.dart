// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hostelms/Login_singup/Services/auth.dart';
// import 'package:hostelms/logsign/screens/login.dart';
// import 'package:hostelms/logsign/screens/profilescreen.dart';

// class Homepage extends StatelessWidget {
//   final String userId;
//   final String userType;

//   const Homepage({Key? key, required this.userId, required this.userType}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home', style: TextStyle(fontSize: 20)),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthServices().signOut();
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (context) => Login(userType: userType),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white,
//               const Color.fromARGB(255, 117, 80, 182),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance.collection('user').doc(userId).get(),
//             builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               }
//               if (!snapshot.hasData || !snapshot.data!.exists) {
//                 return Center(child: Text('No data found'));
//               }

//               // Retrieve data from snapshot
//               var userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
//               var name = userData['full_name'] ?? 'Name not found';
//               var roomNumber = userData['room_number'] ?? 'Room number not found';
//               var block = userData['allocated_hostel'] ?? 'Block not found';

//               return Column(
//                 children: [
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(color: Colors.green),
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(16),
//                       title: Text(
//                         name,
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 8),
//                           Text('Room No.: $roomNumber', style: TextStyle(fontSize: 16)),
//                           Text('Block No.: $block', style: TextStyle(fontSize: 16)),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   // Expanded(
//                   //   child: GridView.count(
//                   //     crossAxisCount: 2,
//                   //     crossAxisSpacing: 10,
//                   //     mainAxisSpacing: 10,
//                   //     children: [
//                   //       _buildCategoryCard('Hostel Card', 'images/pic.png', context),
//                   //       _buildCategoryCard('All Issues', 'images/pic.png', context),
//                   //       _buildCategoryCard('Notifications', 'images/pic.png', context),
//                   //       _buildCategoryCard('Feedback', 'images/pic.png', context),
//                   //     ],
//                   //   ),
//                   // ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryCard(String title, String imagePath, BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: InkWell(
//         onTap: () {
//           // Handle card tap
//           if (title == 'Hostel Card') {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(builder: (context) => ProfileScreen(userId: widget.userId,)), // Replace with your actual screen
//             // );
//           }
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(imagePath, height: 60, width: 60), // Replace with actual image paths
//             SizedBox(height: 10),
//             Text(
//               title,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hostelms/Login_singup/Services/auth.dart';
// import 'package:hostelms/Login_singup/Widget/button.dart';
// import 'package:hostelms/Login_singup/loginscreen.dart';
// import 'package:hostelms/logsign/screens/login.dart';
// import 'package:hostelms/pages/home.dart';

// class Homepage extends StatelessWidget {
//   final String userType;
//   final String userId;

//   const Homepage({super.key, required this.userType, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthServices().signOut();
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (context) => Login(userType: userType),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body:  Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white,
//               const Color.fromARGB(255, 117, 80, 182),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('user')
//             .doc(widget.userId)
//             .snapshots(),
//         builder: (context, usersSnapshot) {
//           if (usersSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (usersSnapshot.hasError) {
//             return Center(
//               child: Text('Error fetching user data: ${usersSnapshot.error}'),
//             );
//           }

//           if (!usersSnapshot.hasData || usersSnapshot.data?.data() == null) {
//             print('No data available for user with ID: ${widget.userId}');
//             return Center(
//               child: Text('No data available for user'),
//             );
//           }

//           Map<String, dynamic> userData1 =
//               usersSnapshot.data!.data() as Map<String, dynamic>;
//           print('User data: $userData1');
 
//         return StreamBuilder<DocumentSnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('hosteliteDetails')
//                 .doc(widget.userId)
//                 .snapshots(),
//             builder: (context, hosteliteDetailsSnapshot) {
//               if (hosteliteDetailsSnapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }

//               if (hosteliteDetailsSnapshot.hasError) {
//                 return Center(
//                   child: Text('Error fetching hostelite details: ${hosteliteDetailsSnapshot.error}'),
//                 );
//               }

//               if (!hosteliteDetailsSnapshot.hasData ||
//                   hosteliteDetailsSnapshot.data?.data() == null) {
//                 print('No data available for hostelite details with ID: ${widget.userId}');
//                 return Center(
//                   child: Text('No data available for hostelite details'),
//                 );
//               }

//               Map<String, dynamic> userData2 =
//                   hosteliteDetailsSnapshot.data!.data() as Map<String, dynamic>;
//               print('Hostelite details data: $userData2');

//               // Combine userData1 and userData2
//               Map<String, dynamic> combinedUserData = {
//                 ...userData1,
//                 ...userData2,
//               };

//               return _buildProfileCard(combinedUserData);
//             },
//           );
//         },
//       ),),
        
//     );
//   }
// }
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hostelms/Login_singup/Services/auth.dart';
// import 'package:hostelms/Login_singup/Widget/button.dart';
// import 'package:hostelms/Login_singup/loginscreen.dart';
// import 'package:hostelms/logsign/screens/login.dart';
// import 'package:hostelms/pages/home.dart';

// class Homepage extends StatelessWidget {
//   final String userType;
//   final String userId;

//   const Homepage({Key? key, required this.userType, required this.userId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthServices().signOut();
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (context) => Login(userType: userType),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white,
//               const Color.fromARGB(255, 117, 80, 182),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildProfileCard(),
//             SizedBox(height: 20),
//             _buildNavigationCard('Tickets', Icons.event_available_outlined, Colors.deepPurple),
//             SizedBox(height: 20),
//             _buildNavigationCard('Announcements', Icons.announcement_outlined, Colors.deepPurple),
//             SizedBox(height: 20),
//             _buildNavigationCard('Leave', Icons.mail_lock_outlined, Colors.deepPurple),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileCard() {
//     return Card(
//       margin: EdgeInsets.all(20),
//       color: Colors.deepPurple,
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Row(
//           children: [
//             Icon(Icons.person, color: Colors.white, size: 30),
//             SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Details',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   // Display user details based on userType
//                   StreamBuilder<DocumentSnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('user')
//                         .doc(userId)
//                         .snapshots(),
//                     builder: (context, userSnapshot) {
//                       if (userSnapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       }

//                       if (userSnapshot.hasError) {
//                         return Center(
//                             child: Text('Error: ${userSnapshot.error}'));
//                       }

//                       if (!userSnapshot.hasData ||
//                           userSnapshot.data?.data() == null) {
//                         return Center(child: Text('No data available'));
//                       }

//                       Map<String, dynamic> userData =
//                           userSnapshot.data!.data() as Map<String, dynamic>;

//                       // Display user details
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('FULL NAME: ${userData['full_name'].toString().toUpperCase()}',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
//                           Text('User Type: $userType',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
                         
//                             Text('Allocated Hostel: ${userData['allocated_hostel']}',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
//                           if (userType == 'hostelite')
//                             Text('Room Number: ${userData['room_number']}',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavigationCard(String title, IconData icon, Color color) {
//     return Card(
//       margin: EdgeInsets.all(20),
//       color: color,
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Icon(icon, color: Colors.white, size: 30),
//             Text(
//               title.toUpperCase(),
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//                 color: Colors.white,
//               ),
//             ),
//             Icon(icon, color: Colors.white, size: 30), // Placeholder for icon on the right
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hostelms/Login_singup/Services/auth.dart';
// import 'package:hostelms/Login_singup/Widget/button.dart';
// import 'package:hostelms/Login_singup/loginscreen.dart';
// import 'package:hostelms/logsign/screens/login.dart';
// import 'package:hostelms/pages/home.dart';

// class Homepage extends StatelessWidget {
//   final String userType;
//   final String userId;

//   const Homepage({Key? key, required this.userType, required this.userId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthServices().signOut();
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (context) => Login(userType: userType),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white,
//               const Color.fromARGB(255, 117, 80, 182),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildProfileCard(),
//             SizedBox(height: 20),
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         if (userType == 'hostelite') {
//                           // Navigate to tickets screen for hostelite
//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => TicketsPage()));
//                         } else if (userType == 'warden') {
//                           // Navigate to tickets screen for warden
//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => WardenTicketsPage()));
//                         }
//                       },
//                       child: _buildNavigationCard('Tickets', Icons.event_available_outlined, Colors.deepPurple),
//                     ),
//                   ),
//                   SizedBox(width: 20),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         if (userType == 'hostelite') {
//                           // Navigate to announcements screen for hostelite
//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementsPage()));
//                         } else if (userType == 'warden') {
//                           // Navigate to announcements screen for warden
//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => WardenAnnouncementsPage()));
//                         }
//                       },
//                       child: _buildNavigationCard('Announcements', Icons.announcement_outlined, Colors.deepPurple),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileCard() {
//     return Card(
//       margin: EdgeInsets.all(20),
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Row(
//           children: [
//             Icon(Icons.person, color: Colors.deepPurple, size: 30),
//             SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Details',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   // Display user details based on userType
//                   StreamBuilder<DocumentSnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('user')
//                         .doc(userId)
//                         .snapshots(),
//                     builder: (context, userSnapshot) {
//                       if (userSnapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       }

//                       if (userSnapshot.hasError) {
//                         return Center(
//                             child: Text('Error: ${userSnapshot.error}'));
//                       }

//                       if (!userSnapshot.hasData ||
//                           userSnapshot.data?.data() == null) {
//                         return Center(child: Text('No data available'));
//                       }

//                       Map<String, dynamic> userData =
//                           userSnapshot.data!.data() as Map<String, dynamic>;

//                       // Display user details
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('FULL NAME: ${userData['full_name'].toString().toUpperCase()}'),
//                           Text('User Type: $userType'),
//                           if (userType == 'hostelite')
//                             Text('Allocated Hostel: ${userData['allocated_hostel']}'),
//                           if (userType == 'hostelite')
//                             Text('Room Number: ${userData['room_number']}'),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavigationCard(String title, IconData icon, Color color) {
//     return Card(
//       margin: EdgeInsets.all(20),
//       color: color,
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Icon(icon, color: Colors.white, size: 30),
//             Text(
//               title.toUpperCase(),
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//                 color: Colors.white,
//               ),
//             ),
//             Icon(icon, color: Colors.white, size: 30), // Placeholder for icon on the right
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hostelms/Login_singup/Services/auth.dart';
// import 'package:hostelms/Login_singup/Widget/button.dart';
// import 'package:hostelms/Login_singup/loginscreen.dart';
// import 'package:hostelms/logsign/screens/login.dart';
// import 'package:hostelms/pages/home.dart';

// class Homepage extends StatelessWidget {
//   final String userType;
//   final String userId;

//   const Homepage({Key? key, required this.userType, required this.userId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthServices().signOut();
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (context) => Login(userType: userType),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white,
//               const Color.fromARGB(255, 117, 80, 182),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildProfileCard(),
//             SizedBox(height: 20),
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         if (userType == 'hostelite') {
//                           // Navigate to tickets screen for hostelite
//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => TicketsPage()));
//                         } else if (userType == 'warden') {
//                           // Navigate to tickets screen for warden
//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => WardenTicketsPage()));
//                         }
//                       },
//                       child: _buildCard('Tickets'),
//                     ),
//                   ),
//                   SizedBox(width: 20),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         if (userType == 'hostelite') {
//                           // Navigate to announcements screen for hostelite
//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementsPage()));
//                         } else if (userType == 'warden') {
//                           // Navigate to announcements screen for warden
//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => WardenAnnouncementsPage()));
//                         }
//                       },
//                       child: _buildCard('Announcements'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileCard() {
//     return Card(
//       margin: EdgeInsets.all(20),
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Details',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 30,
//               ),
//             ),
//             SizedBox(height: 10),
//             // Display user details based on userType
//             StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('user')
//                   .doc(userId)
//                   .snapshots(),
//               builder: (context, userSnapshot) {
//                 if (userSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (userSnapshot.hasError) {
//                   return Center(child: Text('Error: ${userSnapshot.error}'));
//                 }

//                 if (!userSnapshot.hasData || userSnapshot.data?.data() == null) {
//                   return Center(child: Text('No data available'));
//                 }

//                 Map<String, dynamic> userData =
//                     userSnapshot.data!.data() as Map<String, dynamic>;
                
//                 // Display user details
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Full Name: ${userData['full_name']}'),
//                     Text('User Type: $userType'),
//                     if (userType == 'hostelite')
//                       Text('Allocated Hostel: ${userData['allocated_hostel']}'),
//                     if (userType == 'hostelite')
//                       Text('Room Number: ${userData['room_number']}'),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCard(String title) {
//     return Card(
//       margin: EdgeInsets.all(20),
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//             SizedBox(height: 10),
//             // Add more content or icons for each block if needed
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hostelms/Login_singup/Services/auth.dart';
// import 'package:hostelms/Login_singup/Widget/button.dart';
// import 'package:hostelms/Login_singup/loginscreen.dart';
// import 'package:hostelms/logsign/screens/login.dart';
// import 'package:hostelms/pages/home.dart';

// class Homepage extends StatelessWidget {
//   final String userType;
//   final String userId;

//   const Homepage({Key? key, required this.userType, required this.userId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthServices().signOut();
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (context) => Login(userType: userType),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white,
//               const Color.fromARGB(255, 117, 80, 182),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('user')
//               .doc(userId)
//               .snapshots(),
//           builder: (context, userSnapshot) {
//             if (userSnapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             if (userSnapshot.hasError) {
//               return Center(
//                 child: Text('Error fetching user data: ${userSnapshot.error}'),
//               );
//             }

//             if (!userSnapshot.hasData || userSnapshot.data?.data() == null) {
//               print('No data available for user with ID: $userId');
//               return Center(
//                 child: Text('No data available for user'),
//               );
//             }

//             Map<String, dynamic> userData =
//                 userSnapshot.data!.data() as Map<String, dynamic>;
//             print('User data: $userData');

//             // Check userType to conditionally fetch hostelite details
//             if (userType == 'hostelite') {
//               return StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('hosteliteDetails')
//                     .doc(userId)
//                     .snapshots(),
//                 builder: (context, hosteliteDetailsSnapshot) {
//                   if (hosteliteDetailsSnapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }

//                   if (hosteliteDetailsSnapshot.hasError) {
//                     return Center(
//                       child: Text(
//                           'Error fetching hostelite details: ${hosteliteDetailsSnapshot.error}'),
//                     );
//                   }

//                   if (!hosteliteDetailsSnapshot.hasData ||
//                       hosteliteDetailsSnapshot.data?.data() == null) {
//                     print(
//                         'No data available for hostelite details with ID: $userId');
//                     return Center(
//                       child: Text('No data available for hostelite details'),
//                     );
//                   }

//                   Map<String, dynamic> hosteliteData =
//                       hosteliteDetailsSnapshot.data!.data() as Map<String, dynamic>;
//                   print('Hostelite details data: $hosteliteData');

//                   // Combine userData and hosteliteData
//                   Map<String, dynamic> combinedData = {
//                     ...userData,
//                     ...hosteliteData,
//                   };

//                   // Build profile card with combined data
//                   return _buildProfileCard(combinedData);
//                 },
//               );
//             } else {
//               // If userType is not hostelite, just display user data
//               return _buildProfileCard(userData);
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileCard(Map<String, dynamic> userData) {
//     return Center(
//       child: Card(
//         margin: EdgeInsets.all(20),
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'User Details',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text('Full Name: ${userData['full_name']}'),
//               Text('User Type: $userType'),
//                Text('Allocated Hostel: ${userData['allocated_hostel']}'),
//               if (userType == 'hostelite') ...[
               
//                 Text('Room Number: ${userData['room_number']}'),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:hostelms/Login_singup/Services/auth.dart';
// import 'package:hostelms/Login_singup/Widget/button.dart';
// import 'package:hostelms/Login_singup/loginscreen.dart';
// import 'package:hostelms/logsign/screens/login.dart';
// import 'package:hostelms/pages/home.dart';

// class Homepage extends StatelessWidget {
//   final String userType;
//   final String userId;

//   const Homepage({super.key, required this.userType, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             Text(
//               "Successfully logged in as $userType",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 25,
//               ),
//             ),
//             MyButton(
//               onTab: () async {
//                 await AuthServices().signOut();
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => Login(userType: userType),
//                   ),
//                 );
//               },
//               text: "Log out",
//             ),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => Home(userType: userType,)),
//             //     );
//             //   },
//             //   child: Text('Announcements'),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hostelms/Login_singup/Services/auth.dart';
// import 'package:hostelms/logsign/screens/login.dart';

// class Homepage extends StatelessWidget {
//   final String userId;
//   final String userType;

//   const Homepage({Key? key, required this.userId, required this.userType}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard', style: TextStyle(fontSize: 20)),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: CircleAvatar(
//               backgroundImage: AssetImage('assets/profile.png'), // Replace with the actual profile image path
//             ),
//             onPressed: () {
//               // Handle profile image tap
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthServices().signOut();
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (context) => Login(userType: userType),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white,
//               const Color.fromARGB(255, 117, 80, 182),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance.collection('user').doc(userId).get(),
//             builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               }
//               if (!snapshot.hasData || !snapshot.data!.exists) {
//                 return Center(child: Text('No data found'));
//               }

//               // Retrieve data from snapshot
//               var userData = snapshot.data!.data() as Map<String, dynamic>;
//               var name = userData['full_name'] ?? 'Name not found';
//               var roomNumber = userData['room_number'] ?? 'Room number not found';
//               var block = userData['alocated_hostel'] ?? 'Block not found';

//               return Column(
//                 children: [
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(color: Colors.green),
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(16),
//                       title: Text(
//                         name,
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 8),
//                           Text('Room No.: $roomNumber', style: TextStyle(fontSize: 16)),
//                           Text('Block No.: $block', style: TextStyle(fontSize: 16)),
//                         ],
//                       ),
//                       trailing: ElevatedButton.icon(
//                         onPressed: () {
//                           // Handle create issue button press
//                         },
//                         icon: Icon(Icons.create),
//                         label: Text('Create Issue'),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Expanded(
//                     child: GridView.count(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                       children: [
//                         _buildCategoryCard('Hostel Card', 'assets/hostelcard.png'),
//                         _buildCategoryCard('All Issues', 'assets/all_issues.png'),
//                         _buildCategoryCard('Notifications', 'assets/notifications.png'),
//                         _buildCategoryCard('Feedback', 'assets/feedback.png'),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryCard(String title, String imagePath) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: InkWell(
//         onTap: () {
//           // Handle card tap
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(imagePath, height: 60, width: 60), // Replace with actual image paths
//             SizedBox(height: 10),
//             Text(
//               title,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hostelms/Login_singup/Services/auth.dart';
// import 'package:hostelms/logsign/screens/login.dart';

// class Homepage extends StatelessWidget {
//   final String userId;
//   final String userType;

//   const Homepage({Key? key, required this.userId, required this.userType}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard', style: TextStyle(fontSize: 20)),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: CircleAvatar(
//               backgroundImage: AssetImage('assets/profile.png'), // Replace with the actual profile image path
//             ),
//             onPressed: () {
//               // Handle profile image tap
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthServices().signOut();
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (context) => Login(userType: userType),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white,
//               const Color.fromARGB(255, 117, 80, 182),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance.collection('user').doc(userId).get(),
//             builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               }
//               if (!snapshot.hasData || !snapshot.data!.exists) {
//                 return Center(child: Text('No data found'));
//               }

//               // Retrieve data from snapshot
//               var userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
//               var name = userData['full_name'] ?? 'Name not found';
//               var roomNumber = userData['room_number'] ?? 'Room number not found';
//               var block = userData['alocated_hostel'] ?? 'Block not found';

//               return Column(
//                 children: [
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(color: Colors.green),
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(16),
//                       title: Text(
//                         name,
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 8),
//                           Text('Room No.: $roomNumber', style: TextStyle(fontSize: 16)),
//                           Text('Block No.: $block', style: TextStyle(fontSize: 16)),
//                         ],
//                       ),
//                       trailing: ElevatedButton.icon(
//                         onPressed: () {
//                           // Handle create issue button press
//                         },
//                         icon: Icon(Icons.create),
//                         label: Text('Create Issue'),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Expanded(
//                     child: GridView.count(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                       children: [
//                         _buildCategoryCard('Hostel Card', 'assets/hostelcard.png'),
//                         _buildCategoryCard('All Issues', 'assets/all_issues.png'),
//                         _buildCategoryCard('Notifications', 'assets/notifications.png'),
//                         _buildCategoryCard('Feedback', 'assets/feedback.png'),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryCard(String title, String imagePath) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: InkWell(
//         onTap: () {
//           // Handle card tap
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(imagePath, height: 60, width: 60), // Replace with actual image paths
//             SizedBox(height: 10),
//             Text(
//               title,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hostelms/Login_singup/Services/auth.dart';
// import 'package:hostelms/logsign/screens/login.dart'; // Import Firebase Firestore

// class Homepage extends StatelessWidget {
//   final String userType;

//   const Homepage({Key? key, required this.userType}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard', style: TextStyle(fontSize: 20)),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: CircleAvatar(
//               backgroundImage: AssetImage('assets/profile.png'), // Replace with the actual profile image path
//             ),
//             onPressed: () {
//               // Handle profile image tap
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//                 await AuthServices().signOut();
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => Login(userType: userType),
//                   ),
//                 );
//               },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white,
//               const Color.fromARGB(255, 117, 80, 182),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance.collection('user').doc('your_user_id').get(), // Replace with your collection and document ID
//             builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               }
//               if (!snapshot.hasData || !snapshot.data!.exists) {
//                 return Center(child: Text('No data found'));
//               }

//               // Retrieve data from snapshot
//               var userData = snapshot.data!.data();
//               var name = userData['full_name'] ?? 'Name not found';
//               var roomNumber = userData['room_number'] ?? 'Room number not found';
//               var block = userData['alocated_hostel'] ?? 'Block not found';

//               return Column(
//                 children: [
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(color: Colors.green),
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(16),
//                       title: Text(
//                         name,
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 8),
//                           Text('Room No.: $roomNumber', style: TextStyle(fontSize: 16)),
//                           Text('Block No.: $block', style: TextStyle(fontSize: 16)),
//                         ],
//                       ),
//                       trailing: ElevatedButton.icon(
//                         onPressed: () {
//                           // Handle create issue button press
//                         },
//                         icon: Icon(Icons.create),
//                         label: Text('Create Issue'),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Expanded(
//                     child: GridView.count(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                       children: [
//                         _buildCategoryCard('Hostel Card', 'assets/hostelcard.png'), // Replace with actual image paths
//                         _buildCategoryCard('All Issues', 'assets/all_issues.png'),
//                         _buildCategoryCard('Notifications', 'assets/notifications.png'),
//                         _buildCategoryCard('Feedback', 'assets/feedback.png'),

//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryCard(String title, String imagePath) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: InkWell(
//         onTap: () {
//           // Handle card tap
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(imagePath, height: 60, width: 60), // Replace with actual image paths
//             SizedBox(height: 10),
//             Text(
//               title,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }