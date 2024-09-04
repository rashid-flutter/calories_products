import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthNotifier extends StateNotifier<User?> {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _verificationId;

  AuthNotifier(this._auth) : super(null) {
    _auth.authStateChanges().listen((user) {
      state = user;
    });
  }
  String? get verificationId => _verificationId;

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    try {
      // Ensure the phone number is in E.164 format
      final formattedPhoneNumber =
          phoneNumber.startsWith('+') ? phoneNumber : '+${phoneNumber}';

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Save the verification ID for later use
          _verificationId = verificationId;
          // Notify the user to enter the code
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInWithSmsCode(String smsCode) async {
    if (_verificationId == null) {
      print('Verification ID is missing.');
      return;
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in failed.');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      log(e.toString());
    }
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneNumberRegex = RegExp(r'^\+\d{1,15}$');
    return phoneNumberRegex.hasMatch(phoneNumber);
  }
}
