// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class OtpVerificationScreen extends StatefulWidget {
//   final String phoneNumber;
//   final String verificationId;

//   const OtpVerificationScreen({
//     Key? key,
//     required this.phoneNumber,
//     required this.verificationId,
//   }) : super(key: key);

//   @override
//   _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
// }

// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   final _otpController = TextEditingController();
//   bool _isLoading = false;

//   void _verifyOtp() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final smsCode = _otpController.text.trim();

//     if (smsCode.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter the OTP code.')),
//       );
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }

//     try {
//       // Create a credential with the verificationId and the entered OTP
//       final PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: widget.verificationId,
//         smsCode: smsCode,
//       );

//       // Sign the user in using the credential
//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);

//       if (userCredential.user != null) {
//         // Success: Navigate to the desired screen or show success message
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => SuccessScreen()),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Invalid OTP, please try again.')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Verify OTP'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Enter the OTP sent to your phone number',
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               widget.phoneNumber,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               maxLength: 6, // Assuming OTP is 6 digits
//               decoration: InputDecoration(
//                 labelText: 'OTP Code',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _verifyOtp,
//                     child: const Text('Verify OTP'),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SuccessScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Success")),
//       body: Center(
//         child: Text(
//           'Phone number verified successfully!',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
