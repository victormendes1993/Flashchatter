// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchatter/constants.dart';
import 'package:flashchatter/screens/chat_screen.dart';
import 'package:flashchatter/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});
  static const String id = 'email_auth_screen';

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? user;
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;

    if (user != null) {
      isEmailVerified = user!.emailVerified;
    }

    // Listener for user changes
    _auth.userChanges().listen((User? updatedUser) async {
      if (updatedUser != null) {
        setState(() {
          user = updatedUser;
          isEmailVerified = user!.emailVerified;
        });

        if (isEmailVerified) {
          print('email verified');
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                  context, ChatScreen.id, (route) => false);
            });
          }
        }
      }
    });

    // Optionally, add a periodic check for email verification
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    while (user != null && !user!.emailVerified) {
      await Future.delayed(const Duration(seconds: 5));
      await user!.reload();
      setState(() {
        user = _auth.currentUser;
        isEmailVerified = user!.emailVerified;
      });
      if (isEmailVerified) {
        print('email verified');
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
                context, ChatScreen.id, (route) => false);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 100.0),
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
              const SizedBox(
                height: 15.0,
              ),
              const Text(
                textAlign: TextAlign.center,
                'Please check your email.',
                style: kScreenTextBlackBold,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                textAlign: TextAlign.center,
                'We\'ve sent an email verification to ${user?.email}',
                style: kScreenTextBlackBold,
              ),
              const SizedBox(
                height: 15.0,
              ),
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              const Text(
                textAlign: TextAlign.center,
                'Verifying email...',
                style: kScreenTextBlackBold,
              ),
              const SizedBox(
                height: 30.0,
              ),
              RoundedButton(
                color: Colors.blueAccent,
                text: 'Resend',
                onPressed: () async {
                  if (user != null) {
                    await user!.sendEmailVerification();
                  }
                  print('Verification email sent.');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
