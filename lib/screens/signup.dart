import 'package:easy_first_aid/screens/login.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passswordController = TextEditingController();

  bool _isChecked = false; // Checkbox state

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  // void signup(String email, String password) async {
  //   // Your signup logic here
  // }

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
                'https://plus.unsplash.com/premium_photo-1701534008693-0eee0632d47a?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8d2Vic2l0ZSUyMGJhY2tncm91bmR8ZW58MHx8MHx8fDA%3D', // Replace with your network image URL
                fit: BoxFit.cover,
              ),
            ),
            // Foreground Content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    const Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 19, 18, 18),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Fill your information below',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 52, 50, 50),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    CustomTextField(
                      label: 'Email',
                      hintText: 'example@gmail.com',
                      obscureText: false,
                      controller: _emailController,
                    ),
                    CustomTextField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      isPasswordField: true,
                      obscureText: true,
                      controller: _passswordController,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 0, 10),
                          child: Checkbox(
                            value: _isChecked,
                            onChanged: _toggleCheckbox,
                            activeColor: const Color.fromARGB(255, 51, 49, 49),
                            checkColor: Colors.white,
                          ),
                        ),
                        const Text("Agree with "),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Terms and Conditions"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 51, 49, 49),
                          fixedSize: const Size(350, 60),
                        ),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Sign in"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPasswordField;
  final ValueChanged<String>? onChanged;
  final double width;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.isPasswordField = false,
    this.onChanged,
    this.width = double.infinity,
    required this.obscureText,
    this.controller,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget
        .isPasswordField; // Initialize obscureText based on isPasswordField
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText; // Toggle the obscureText state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: widget.width, // Set the width of the container
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.isPasswordField ? _obscureText : false,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: widget.hintText,
                filled: true,
                fillColor: const Color.fromARGB(255, 213, 210, 210),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: widget.isPasswordField
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _toggleObscureText,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
