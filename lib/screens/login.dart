import 'dart:convert';

import 'package:easy_first_aid/Services/apiservice.dart';
import 'package:easy_first_aid/screens/homescreen.dart';
import 'package:easy_first_aid/screens/signup.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginn(String email, String password) async {
    try {
      var result = await ApiService(
              baseUrl: 'https://expresscarr.pythonanywhere.com/api/user/')
          .postRequest('login/', {'email': email, 'password': password});

      if (result.statusCode == 200) {
        var response = jsonDecode(result.body);
        print("Login successful:  ${result.statusCode}- $response");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Homescreen()));
      } else {
        print(
            "Unsuccessful response: Error--------------- ${result.statusCode}- ${result.body}");
        // Handle different status codes or errors
      }
    } catch (e) {
      print("Errorrrr: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(
                'https://plus.unsplash.com/premium_photo-1701534008693-0eee0632d47a?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8d2Vic2l0ZSUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D',
                fit: BoxFit.cover,
              ),
            ),
            // Foreground Content
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  const Center(
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 19, 18, 18),
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Hi! Welcome back, you have been missed',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 65, 63, 63),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Username',
                    hintText: 'example@gmail.com',
                    obscureText: false,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hintText: 'Enter your password',
                    isPasswordField: true,
                    obscureText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              // Add Forgot Password Functionality
                            },
                            child: const Text(
                              "Forgot Password",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 71, 69, 69),
                                  decoration: TextDecoration.underline),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      loginn(_emailController.text.toString(),
                          _passwordController.text.toString());
                      // Add Sign in Functionality
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const Homescreen()));
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                        255,
                        51,
                        49,
                        49,
                      ),
                      fixedSize: const Size(350, 60),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 65, right: 10),
                        child: SizedBox(
                          width: 100, // Set the width of the left divider
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                      ),
                      Text("Or Sign in with"),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: 100, // Set the width of the left divider
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Social Media Login Buttons (Uncomment if needed)
                  // Row(
                  //   children: [
                  //     ImageWithEllipse(
                  //       imagePath: 'assets/images/g10.png',
                  //       padding: const EdgeInsets.fromLTRB(70, 40, 10, 40),
                  //       onTap: () {},
                  //     ),
                  //     const SizedBox(width: 20),
                  //     ImageWithEllipse(
                  //       imagePath: 'assets/images/Group.png',
                  //       padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                  //       onTap: () {},
                  //     ),
                  //     const SizedBox(width: 10),
                  //     ImageWithEllipse(
                  //       imagePath: 'assets/images/Group_18.png',
                  //       padding: const EdgeInsets.fromLTRB(20, 40, 10, 40),
                  //       onTap: () {},
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Signup(
                                          email: '',
                                        )));
                          },
                          child: const Text("Sign up"))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
