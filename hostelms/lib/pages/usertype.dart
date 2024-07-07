
import 'package:flutter/material.dart';
import 'package:hostelms/logsign/screens/login.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;

 double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              // width: double.infinity,
              // height: height / 2, // Image takes half of the screen height
              // child: Image.asset('images/hostel.jpg', fit: BoxFit.cover),
                width: screenWidth , // Image takes 80% of the screen width
              child: AspectRatio(
                aspectRatio: 16 / 9, // Adjust the aspect ratio as per your image
                child: Image.asset('images/hostel.jpg', fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 80), // Space between image and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    navigateToLoginScreen(context, 'warden');
                  },
                  child: Text('Warden',style: TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                SizedBox(width: 40), // Space between buttons
                ElevatedButton(
                  onPressed: () {
                    navigateToLoginScreen(context, 'hostelite');
                  },
                  child: Text('Hostelite',
                  style: TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.bold
                  ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void navigateToLoginScreen(BuildContext context, String userType) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login(userType: userType)),
    );
  }
}
