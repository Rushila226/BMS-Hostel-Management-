import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


Future<String> signUpUser(
    {required String email,
    required String password,
    required String name}) async {
  String res = "";
  try {
    UserCredential credential=await _auth.createUserWithEmailAndPassword(email: email, password: password) ;
    await _firestore.collection("users").doc(credential.user!.uid).set({
      'name':name,
      "email":email,
      'uid':credential.user!.uid,

    });
    res="Successfulley";
  } catch (e) {
    print("error sign :{$e.toString()}");
       res = "Some error occurred: ${e.toString()}"; // Update res upon error
      // Handle specific error types if needed
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            res = "Email already in use.";
            break;
          case 'weak-password':
            res = "The password provided is too weak.";
            break;
          default:
            res = "Sign up failed. Please try again later.";
            break;
        }
      }
  }
  return res;
}
}
