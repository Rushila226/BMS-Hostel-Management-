

import 'package:flutter/material.dart';
import 'package:hostel/Login_Signup/Services/auth.dart';
import 'package:hostel/Login_Signup/Widget/button.dart';
import 'package:hostel/Login_Signup/Widget/snackbar.dart';
import 'package:hostel/Login_Signup/Widget/textfield.dart';
import 'package:hostel/Login_Signup/loginscreen.dart';
import 'package:hostel/home.dart';






class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading=false;
  void signUpUser() async {
    String res = await AuthServices().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text);

    if (res == "success") {
      setState(() {
        isLoading=true;

      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Homescreen(),
        ),
      );
    }
    else{
      setState(() {
        isLoading=false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SizedBox(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: height / 2.7,
                    child: Image.asset('images/sign.jpeg'),
                  ),
                  TextfieldInpute(
                    textEditingController: nameController,
                    hintText: "Enter your name",
                    icon: Icons.person,
                  ),
                  TextfieldInpute(
                    textEditingController: emailController,
                    hintText: "Enter your email",
                    icon: Icons.email,
                  ),
                  TextfieldInpute(
                    textEditingController: passwordController,
                    hintText: "Enter your password",
                    icon: Icons.lock,
                  ),
                  MyButton(onTab:signUpUser, text: "Sign Up"),
                  SizedBox(height: height / 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already Have an account? ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Loginscreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "LogIn",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
          ),
        ));
  }
}
