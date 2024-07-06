import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/services.dart';
// // import 'package:firebase_core/firebase_core.dart';

// class AuthServices {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;


// Future<String> signUpUser(
//     {required String email,
//     required String password,
//     required String name,
//     }) async {
//   String res = "";
//   try {
//     if(email.isNotEmpty||password.isNotEmpty||name.isNotEmpty)
//     {
//       UserCredential credential=await _auth.createUserWithEmailAndPassword(email: email, password: password) ;
//       await _firestore.collection("users").doc(credential.user!.uid).set({
//       'name':name,
//       "email":email,
//       'uid':credential.user!.uid,

//     });
//     res="success";
//     }
    
//   } catch (e) {
//     print("error sign :{$e.toString()}");
//        res = "Some error occurred: ${e.toString()}"; // Update res upon error
//       // Handle specific error types if needed
//       if (e is FirebaseAuthException) {
//         switch (e.code) {
//           case 'email-already-in-use':
//             res = "Email already in use.";
//             break;
//           case 'weak-password':
//             res = "The password provided is too weak.";
//             break;
//           default:
//             res = "Sign up failed. Please try again later.";
//             break;
//         }
//       }
//   }
//   return res;
// }

//   Future<String> loginUser(
//     {required String email,
//     required String password,
//    }) async {
//     String res="Some error occured";
//       try {
//     if(email.isNotEmpty && password.isNotEmpty)
//     {
//       await _auth.signInWithEmailAndPassword(email: email, password: password) ;
//       res="success";
      

//     }
//     else{
//       res="please enter all the field";
//     }
//       }
//     catch(e){
    
     
    
      
//     print("error sign :{$e.toString()}");

//        if (e is FirebaseAuthException) {
//       switch (e.code) {
//         case 'user-not-found':
//           res = "User not found. Please check your email.";
//           break;
//         case 'wrong-password':
//           res = "Wrong password. Please try again.";
//           break;
//         default:
//           res = e.message?? "Login failed. Please try again later.";
//           break;
//      }
//      }else{
//       res ="Login failed. ${e.toString()}";

//       }
       
//     }
      
    
//   return res;
//    }



//    Future <void> signOut()async{
//     await _auth.signOut();
//    }
// }

// class AuthServices {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<String> signUpUser({required String email, required String password, required String name}) async {
//     String res = "";
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       await _firestore.collection("users").doc(credential.user!.uid).set({
//         'name': name,
//         "email": email,
//         'uid': credential.user!.uid,
//         'userType': 'hostelite', // Default user type for signup
//       });
//       res = "success";
//     } catch (e) {
//       print("error sign :{$e.toString()}");
//       res = "Some error occurred: ${e.toString()}";
//       // Handle specific error types if needed
//       if (e is FirebaseAuthException) {
//         switch (e.code) {
//           case 'email-already-in-use':
//             res = "Email already in use.";
//             break;
//           case 'weak-password':
//             res = "The password provided is too weak.";
//             break;
//           default:
//             res = "Sign up failed. Please try again later.";
//             break;
//         }
//       }
//     }
//     return res;
//   }

//   Future<String> loginUser({required String email, required String password}) async {
//     String res = "Some error occurred";
//     try {
//       if (email.isNotEmpty && password.isNotEmpty) {
//         await _auth.signInWithEmailAndPassword(email: email, password: password);
//         res = "success";
//       } else {
//         res = "Please enter all fields";
//       }
//     } catch (e) {
//       print("error sign :{$e.toString()}");

//       if (e is FirebaseAuthException) {
//         switch (e.code) {
//           case 'user-not-found':
//             res = "User not found. Please check your email.";
//             break;
//           case 'wrong-password':
//             res = "Wrong password. Please try again.";
//             break;
//           default:
//             res = e.message ?? "Login failed. Please try again later.";
//             break;
//         }
//       } else {
//         res = "Login failed. ${e.toString()}";
//       }
//     }

//     return res;
//   }

//   Future<String> getUserType(String email) async {
//     String userType = '';
//     try {
//       DocumentSnapshot snapshot = await _firestore.collection('users').doc(email).get();
//       userType = snapshot.get('userType') ?? '';
//     } catch (e) {
//       print("Error getting user type: $e");
//     }
//     return userType;
 
//   }
//     Future <void> signOut()async{
//     await _auth.signOut();
//    }
// }


class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({required String email, required String password, required String name, required String userType}) async {
    String res = "";
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection("users").doc(credential.user!.uid).set({
        'name': name,
        "email": email,
        'uid': credential.user!.uid,
        'userType': userType, // Assigning user type based on selection
      });
      res = "success";
    } catch (e) {
      print("Error signing up: ${e.toString()}");
      res = "Some error occurred: ${e.toString()}";
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

  Future<String> loginUser({required String email, required String password}) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all fields";
      }
    } catch (e) {
      print("Error signing in: ${e.toString()}");

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            res = "User not found. Please check your email.";
            break;
          case 'wrong-password':
            res = "Wrong password. Please try again.";
            break;
          default:
            res = e.message ?? "Login failed. Please try again later.";
            break;
        }
      } else {
        res = "Login failed. ${e.toString()}";
      }
    }

    return res;
  }

  Future<String> getUserType(String email) async {
    String userType = '';
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(email).get();
      userType = snapshot.get('userType') ?? '';
    } catch (e) {
      print("Error getting user type: $e");
    }
    return userType;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
