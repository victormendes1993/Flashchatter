// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchatter/constants.dart';
import 'package:flashchatter/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const String id = 'forgot_password_screen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();

    // Listen for auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        // User is signed out, possibly due to password reset
        print("User is signed out.");
      } else {
        print("User is signed in: ${user.email}");
        // Here you can check if the user changed the password
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'images/logo.png',
                    height: 200,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Type your email address below.',
                  textAlign: TextAlign.center,
                  style: kScreenTextBlackBold,
                ),
                const SizedBox(height: 30),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.start,
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Email...'),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                const SizedBox(height: 20),
                RoundedButton(
                  color: Colors.blueAccent,
                  text: 'Send',
                  onPressed: () => passwordResetEmail(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void passwordResetEmail() async {
    setState(() {
      showSpinner = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: email);

      if (!mounted) return; // Check if the widget is still mounted

      // Use WidgetsBinding to handle context-dependent operations
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Password Reset'),
              content: const Text(
                  'A password reset link has been sent to your email.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context); // Return to the previous screen
                  },
                ),
              ],
            );
          },
        );
      });

      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print(e);
      // Show an error dialog here if needed
    }
  }
}
