import 'package:flutter/material.dart';

import '../../core/App_Colors/Colors.dart';
import '../../core/App_Picture/picture.dart';
import '../Auth_Service/Auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.nescafeLight,

        body: Padding(
          padding: const EdgeInsets.all(24),

          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),

                SizedBox(
                  height: 200,
                  width: 200,

                  child: Image.asset(
                    Picture.ForgotPassword,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Enter your email and we will send you a password reset link",
                  textAlign: TextAlign.center,

                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: emailController,

                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(
                    hintText: "Email",

                    filled: true,

                    fillColor: AppColors.white,

                    prefixIcon: const Icon(Icons.email_outlined),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed: () async {
                      String message = await Auth.forgotPassword(
                        emailController.text.trim(),
                      );

                      Auth.showSnackBar(context, message);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      "Send Code",

                      style: TextStyle(color: AppColors.red, fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text("Back to Sign In"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
