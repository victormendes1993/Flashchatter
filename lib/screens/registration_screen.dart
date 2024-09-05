// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchatter/constants.dart';
import 'package:flashchatter/screens/chat_screen.dart';
import 'package:flashchatter/screens/email_auth_screen.dart';
import 'package:flashchatter/widgets/rounded_button.dart';
import 'package:flashchatter/widgets/show_error_dialog.dart';
import 'package:flashchatter/widgets/square_rounded_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final Future<UserCredential> Function() googleCredential;
  late String email;
  late String password;

  bool showSpinner = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 140.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'images/logo.png',
                    height: 200,
                  ),
                ),
                const Text(
                  textAlign: TextAlign.center,
                  'Welcome to Flashchatter!',
                  style: kScreenTextBlackBold,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Email...'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Password...'),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  color: Colors.blueAccent,
                  text: 'Register',
                  padding: const EdgeInsets.only(bottom: 15.0),
                  onPressed: () {
                    _registerWithEmail();
                  },
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Divider(
                          color: Colors.black12, height: 20, thickness: 1),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        ' Or register with ',
                        style: kScreenTextGrey,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                          color: Colors.black12, height: 20, thickness: 1),
                    )
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareRoundedTile(
                      imageName: 'images/glogo.png',
                      onPress: () {
                        _signInWithGoogle();
                      },
                    ),
                    const SizedBox(width: 30.0),
                    SquareRoundedTile(
                      imageName: 'images/fblogo.png',
                      onPress: () {
                        print('test2');
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    emailController.clear();
    passwordController.clear();

    setState(() {
      showSpinner = true;
    });

    try {
      // Begin sign in process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;
      Navigator.pushNamed(context, ChatScreen.id);
    } catch (e) {
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      showErrorDialog(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
    }
  }

  Future<void> _registerWithEmail() async {
    emailController.clear();
    passwordController.clear();

    setState(() {
      showSpinner = true;
    });

    try {
      // Register the user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the current user
      User? user = userCredential.user;

      // Check if the user exists and is not verified
      if (user != null && !user.emailVerified) {
        // Set the language code for Brazilian Portuguese
        _auth.setLanguageCode('pt-BR');
        // Send the email verification
        await user.sendEmailVerification();
        print('Verification email sent.');

        if (mounted) {
          // Use addPostFrameCallback to ensure navigation occurs after the frame is complete
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(context, EmailAuthScreen.id);
          });
        }
      } else {
        print('User is either null or already verified.');
      }
    } catch (e) {
      if (mounted) {
        showErrorDialog(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
    }
  }
}
