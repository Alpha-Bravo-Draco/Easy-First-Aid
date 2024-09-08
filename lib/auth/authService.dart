import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credentials.user;
    } catch (e) {
      print("Error----------------${e.toString()}");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credentials.user;
    } catch (e) {
      print("Error----------------${e.toString()}");
    }
    return null;
  }

  // Corrected signInWithPhone method
  void signInWithPhone(
      BuildContext context,
      String phoneNumber,
      Function(String) onVerificationIdReceived,
      Function(String) onCodeSent) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto verification completed
          await _auth.signInWithCredential(credential);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Phone number automatically verified'),
          ));
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle failed verification
          print('Verification failed: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Verification failed: ${e.message}'),
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          // SMS code sent
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Code sent to $phoneNumber'),
          ));
          // Call the callback function to store verificationId
          onVerificationIdReceived(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout for automatic code retrieval
          onVerificationIdReceived(verificationId);
        },
        timeout:
            const Duration(seconds: 60), // Timeout for automatic verification
      );
    } catch (e) {
      print("Error----------------${e.toString()}");
    }
  }

  // Future<void> verifyOTP(
  //     String verificationId, String smsCode, BuildContext context) async {
  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId,
  //       smsCode: smsCode,
  //     );

  //     await _auth.signInWithCredential(credential);
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Phone number verified successfully'),
  //     ));
  //   } catch (e) {
  //     print("Error during OTP verification: ${e.toString()}");
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Failed to verify OTP'),
  //     ));
  //   }
  // }
}
