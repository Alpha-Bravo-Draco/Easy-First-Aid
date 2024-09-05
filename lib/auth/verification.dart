// // import 'dart:convert';
// // import 'package:easy_first_aid/Services/apiservice.dart';
// // import 'package:easy_first_aid/auth/login.dart';
// import 'package:flutter/material.dart';
// import 'package:pin_code_text_field/pin_code_text_field.dart';
// // import 'package:flutter_application_2/Services/ApiBaseServices/api_base_services.dart';
// // import 'package:flutter_application_2/screens/location.dart';
// // // import 'package:http/http.dart' as http;
// // import 'package:pin_code_text_field/pin_code_text_field.dart';

// class Verification extends StatefulWidget {
//   final String email; // Add the email parameter

//   const Verification({
//     Key? key,
//     required this.email,
//   }) : super(key: key);

//   @override
//   State<Verification> createState() => _VerificationState();
// }

// class _VerificationState extends State<Verification> {
//   bool hasError = false;
//   int pinLength = 4;
//   final TextEditingController otpController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();

//   // Future<void> verifyOtp(String code) async {
//   //   try {
//   //     var result = await ApiService(
//   //             baseUrl: 'https://expresscarr.pythonanywhere.com/api/user/api/')
//   //         .postRequest(
//   //       'verify-otp/',
//   //       {'code': code},
//   //     );

//   //     if (result.statusCode == 200) {
//   //       var response = jsonDecode(result.body);
//   //       print("Otp sent Successfully------: ${result.statusCode} - $response");
//   //       Navigator.push(
//   //         context,
//   //         MaterialPageRoute(builder: (context) => const Login()),
//   //       );
//   //     } else {
//   //       _showErrorDialog('Wrong Otp', 'Please try again.');
//   //       print("Error------------: ${result.statusCode} - ${result.body}");
//   //     }
//   //   } catch (e) {
//   //     print("Error-----------------${e.toString()}");
//   //   }
//   // }

//   // Future<void> resendOtp() async {
//   //   try {
//   //     var result = await ApiService(
//   //             baseUrl: 'https://expresscarr.pythonanywhere.com/api/user/')
//   //         .postRequest(
//   //       'api/resend_otp/',
//   //       {'email': widget.email},
//   //     );

//   //     if (result.statusCode == 200) {
//   //       var response = jsonDecode(result.body);
//   //       print("Otp sent Successfully------: ${result.statusCode} - $response");
//   //     } else {
//   //       print("Error------------: ${result.statusCode} - ${result.body}");
//   //     }
//   //   } catch (e) {
//   //     print("Error-----------------${e.toString()}");
//   //   }
//   // }

//   void _showErrorDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: Text("OK"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 100),
//             const Center(
//               child: Text(
//                 'Verify Code',
//                 style: TextStyle(
//                   fontSize: 30,
//                   color: Color.fromARGB(255, 19, 18, 18),
//                   decoration: TextDecoration.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Center(
//               child: Text(
//                 'Please enter the code we just sent you to email\nexample@gmail.com',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Colors.grey,
//                   decoration: TextDecoration.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             // SizedBox(
//             //   child: Image.asset(
//             //     'assets/images/g9.png',
//             //     width: 250,
//             //   ),
//             // ),
//             const SizedBox(height: 40),
//             Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   PinCodeTextField(
//                     pinBoxRadius: 10,
//                     autofocus: true,
//                     controller: otpController,
//                     hideCharacter: false,
//                     highlight: true,
//                     defaultBorderColor:
//                         const Color.fromARGB(255, 153, 153, 153),
//                     hasTextBorderColor:
//                         const Color.fromARGB(255, 153, 153, 153),
//                     highlightPinBoxColor:
//                         const Color.fromARGB(255, 153, 153, 153),
//                     maxLength: pinLength,
//                     hasError: hasError,
//                     onTextChanged: (text) {
//                       setState(() {
//                         hasError = false;
//                       });
//                     },
//                     onDone: (text) {
//                       print("DONE $text");
//                       print("DONE CONTROLLER ${otpController.text}");
//                     },
//                     pinBoxWidth: 80,
//                     pinBoxHeight: 60,
//                     hasUnderline: false,
//                     wrapAlignment: WrapAlignment.spaceEvenly,
//                     pinBoxDecoration:
//                         ProvidedPinBoxDecoration.defaultPinBoxDecoration,
//                     pinTextStyle: TextStyle(fontSize: 22.0),
//                     pinTextAnimatedSwitcherTransition:
//                         ProvidedPinBoxTextAnimation.scalingTransition,
//                     pinTextAnimatedSwitcherDuration:
//                         Duration(milliseconds: 400),
//                     highlightAnimationBeginColor:
//                         const Color.fromARGB(255, 153, 153, 153),
//                     highlightAnimationEndColor: Colors.white12,
//                     keyboardType: TextInputType.number,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             const Text(
//               "Didn't receive the OTP?",
//               style: TextStyle(fontSize: 16),
//             ),
//             TextButton(
//               onPressed: () {
//                 // resendOtp(); // Call resendOtp when button is pressed
//               },
//               child: const Text(
//                 "Resend Code",
//                 style: TextStyle(
//                     color: Colors.black, decoration: TextDecoration.underline),
//               ),
//             ),
//             SizedBox(height: 50),
//             ElevatedButton(
//               onPressed: () {
//                 // verifyOtp(otpController.text.toString());
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 51, 49, 49),
//                 fixedSize: const Size(350, 60),
//               ),
//               child: const Text(
//                 "Verify",
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthExample extends StatefulWidget {
  @override
  _PhoneAuthExampleState createState() => _PhoneAuthExampleState();
}

class _PhoneAuthExampleState extends State<PhoneAuthExample> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _verificationId = '';
  bool _isLoading = false;

  void _sendOTP() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-resolving OTP
        await _auth.signInWithCredential(credential);
        setState(() {
          _isLoading = false;
        });
        // Handle successful verification
        print("Phone verified automatically");
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isLoading = false;
        });
        // Handle error
        print("Verification failed: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message ?? "Verification failed"),
        ));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _isLoading = false;
          _verificationId = verificationId;
        });
        // Handle OTP sent to the user
        print("OTP sent to phone number");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle code auto-retrieval timeout
        setState(() {
          _verificationId = verificationId;
        });
        print("Code auto retrieval timeout");
      },
    );
  }

  void _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _otpController.text,
    );

    try {
      await _auth.signInWithCredential(credential);
      setState(() {
        _isLoading = false;
      });
      // Handle successful login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Phone verified successfully")),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error during OTP verification
      print("Error during OTP verification: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to verify OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                hintText: "+1 555-555-5555",
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendOTP,
                    child: Text("Send OTP"),
                  ),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: "Enter OTP"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOTP,
                    child: Text("Verify OTP"),
                  ),
          ],
        ),
      ),
    );
  }
}
