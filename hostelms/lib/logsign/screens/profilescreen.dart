
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Print userId to debug console
    print('User ID: ${widget.userId}');
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, usersSnapshot) {
          if (usersSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (usersSnapshot.hasError) {
            return Center(
              child: Text('Error fetching user data: ${usersSnapshot.error}'),
            );
          }

          if (!usersSnapshot.hasData || usersSnapshot.data?.data() == null) {
            print('No data available for user with ID: ${widget.userId}');
            return Center(
              child: Text('No data available for user'),
            );
          }

          Map<String, dynamic> userData1 =
              usersSnapshot.data!.data() as Map<String, dynamic>;
          print('User data: $userData1');

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('hosteliteDetails')
                .doc(widget.userId)
                .snapshots(),
            builder: (context, hosteliteDetailsSnapshot) {
              if (hosteliteDetailsSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (hosteliteDetailsSnapshot.hasError) {
                return Center(
                  child: Text('Error fetching hostelite details: ${hosteliteDetailsSnapshot.error}'),
                );
              }

              if (!hosteliteDetailsSnapshot.hasData ||
                  hosteliteDetailsSnapshot.data?.data() == null) {
                print('No data available for hostelite details with ID: ${widget.userId}');
                return Center(
                  child: Text('No data available for hostelite details'),
                );
              }

              Map<String, dynamic> userData2 =
                  hosteliteDetailsSnapshot.data!.data() as Map<String, dynamic>;
              print('Hostelite details data: $userData2');

              // Combine userData1 and userData2
              Map<String, dynamic> combinedUserData = {
                ...userData1,
                ...userData2,
              };

              return _buildProfileCard(combinedUserData);
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> userData) {
    return Center(
      child: Container(
        width: 350,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'HOSTEL CARD',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : NetworkImage(userData['photoUrl'] ?? 'https://via.placeholder.com/150')
                        as ImageProvider,
                child: _imageFile == null
                    ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              userData['full_name'] ?.toUpperCase() ?? 'N/A',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20.0),
            _buildInfoRow('USN', userData['roll_number']),
            _buildInfoRow('Email', userData['email']),
            _buildInfoRow('Allotted Hostel', userData['allocated_hostel']),
            _buildInfoRow('Room No.', userData['room_number']),
            _buildInfoRow('Contact No.', userData['contact_number']),
            _buildInfoRow('Course', userData['course']),
            _buildInfoRow('Parent Name', userData['parent_name']),
            _buildInfoRow('Parent No.', userData['parent_phone_number']),
            _buildInfoRow('D.O.B', userData['date_of_birth']),
            SizedBox(height: 20.0),
          
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value ?? 'N/A',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
