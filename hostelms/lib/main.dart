
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostelms/local_notifications/noticlass.dart';
import 'package:hostelms/pages/navigation.dart';
import 'package:hostelms/pages/usertype.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationServices notificationServices = NotificationServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final user = snapshot.data;

          if (user == null) {
            return UserTypeSelectionScreen();
          } else {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('user').doc(user.uid).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return Scaffold(
                    body: Center(
                      child: Text('User data not found'),
                    ),
                  );
                }

                final data = userSnapshot.data!.data() as Map<String, dynamic>?;
                final userType = data != null && data.containsKey('user_type') ? data['user_type'] : '';

                if (userType == 'warden') {
                  return Navigation(userType: 'warden', userId: user.uid);
                } else if (userType == 'hostelite') {
                  return Navigation(userType: 'hostelite', userId: user.uid);
                } else {
                  return Scaffold(
                    body: Center(
                      child: Text('Unknown user type'),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
