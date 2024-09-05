import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchatter/constants.dart';
import 'package:flashchatter/screens/chat_screen.dart';
import 'package:flashchatter/screens/forgot_password_screen.dart';
import 'package:flashchatter/screens/registration_screen.dart';
import 'package:flashchatter/widgets/rounded_button.dart';
import 'package:flashchatter/widgets/show_error_dialog.dart';
import 'package:flashchatter/widgets/square_rounded_tile.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  late Animation animationLogo;
  late String email;
  late String password;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    animation = ColorTween(
      begin: Colors.blueGrey.shade100,
      end: Colors.white,
    ).animate(animationController);

    animationLogo = CurvedAnimation(
      parent: animationController,
      curve: Curves.decelerate,
    );

    animationController.forward();

    animationController.addListener(() {
      setState(() {});
    });
  } //initState

  @override
  void dispose() {
    animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: animation.value,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 25.0,
            top: 180.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Image.asset(
                        'images/logo.png',
                        height: animationLogo.value * 100,
                      ),
                    ),
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'FlashChatter',
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 35.0,
                          fontWeight: FontWeight.w900,
                        ),
                        speed: const Duration(
                          milliseconds: 100,
                        ),
                      ),
                    ],
                    totalRepeatCount: 1,
                  )
                ],
              ),
              const SizedBox(height: 50.0),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.start,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Email...'),
                onChanged: (value) {
                  email = value;
                },
              ),
              const SizedBox(height: 8.0),
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
              GestureDetector(
                child: const Text(
                  textAlign: TextAlign.end,
                  'Forgot Password?',
                  style: kScreenTextBlueAccent,
                ),
                onTap: () {
                  Navigator.pushNamed(context, ForgotPasswordScreen.id);
                },
              ),
              RoundedButton(
                color: Colors.blueAccent,
                text: 'Log In',
                onPressed: () {
                  _loginWithEmail(context);
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
                      ' Or login with ',
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
                      // ignore: avoid_print
                      print('test2');
                    },
                  )
                ],
              ),
              const SizedBox(height: 50),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Not a member?',
                      style: kScreenTextGrey,
                    ),
                    TextSpan(
                      text: ' Register now.',
                      style: kScreenTextBlueAccent,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            Navigator.pushNamed(context, RegistrationScreen.id);
                          });
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginWithEmail(BuildContext context) async {
    setState(() {
      showSpinner = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // ignore: avoid_print
      print(_auth.currentUser!.email);
      if (mounted) {
        emailController.clear();
        passwordController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, ChatScreen.id);
        });
      }
    } catch (e) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showErrorDialog(context, e.toString());
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          showSpinner = false; // Safe to update UI
        });
      }
    }
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
      await _auth.signInWithCredential(credential);

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
  } //signInWithGoogle
} //WelcomeScreenState
