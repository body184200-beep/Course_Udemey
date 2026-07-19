import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign In
  static Future<String> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return "Signed in successfully";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Something went wrong";
    } catch (e) {
      return "Something went wrong";
    }
  }

  // Sign Up
  static Future<String> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "Account created successfully";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Something went wrong";
    } catch (e) {
      return "Something went wrong";
    }
  }

  // Forgot Password
  static Future<String> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      return "Password reset email sent";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Something went wrong";
    } catch (e) {
      return "Something went wrong";
    }
  }

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // Current User
  static User? get currentUser {
    return _auth.currentUser;
  }

  // Sign In Handler
  static Future<void> signInHandling(
    String email,
    String password,
    BuildContext context,
  ) async {
    String message = await Auth.signInWithEmail(email, password);

    showSnackBar(context, message);
  }

  // SnackBar
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
