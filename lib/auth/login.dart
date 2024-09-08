import 'package:easy_first_aid/auth/signup.dart';
import 'package:easy_first_aid/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Show loading indicator
  void _showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // Hide loading indicator
  void _hideLoadingIndicator() {
    Navigator.of(context).pop();
  }

  // Method to handle login
  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      _showLoadingIndicator(); // Show loading indicator
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        _hideLoadingIndicator(); // Hide loading indicator

        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homescreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        _hideLoadingIndicator(); // Hide loading indicator on error
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No user found for that email.")),
          );
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Wrong password provided.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.message}")),
          );
        }
      } catch (e) {
        _hideLoadingIndicator(); // Hide loading indicator on error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in both fields.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents resizing when keyboard shows
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://plus.unsplash.com/premium_photo-1701534008693-0eee0632d47a?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8d2Vic2l0ZSUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D',
                ),
                fit: BoxFit.cover, // Ensures the image covers the entire screen
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.11),
                const Center(
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 19, 18, 18),
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
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
                SizedBox(height: screenHeight * 0.04),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
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
                          // Forgot password logic
                        },
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: Color.fromARGB(255, 71, 69, 69),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 51, 49, 49),
                    fixedSize: const Size(350, 60),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          "Sign in",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                ),
                SizedBox(height: screenHeight * 0.034),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 65, right: 10),
                      child: SizedBox(
                        width: screenWidth * 0.233,
                        // Set the width of the left divider
                        child: const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                    ),
                    const Text("Or Sign in with"),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        width: screenWidth *
                            0.233, // Set the width of the right divider
                        child: const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Signup(email: ''),
                          ),
                        );
                      },
                      child: const Text("Sign up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}