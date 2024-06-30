import 'package:flutter/material.dart';
import 'package:hostel/Login_Signup/Widget/button.dart';
import 'package:hostel/Login_Signup/Widget/textfield.dart';
import 'package:hostel/Login_Signup/singup.dart';


class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Loginscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                    child: Image.asset('images/login.jpg'),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 35,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  MyButton(onTab: () {}, text: "Log In"),
                  SizedBox(height: height / 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Dont have an account? ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "SignUp",
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
