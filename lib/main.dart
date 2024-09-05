import 'package:firebase_core/firebase_core.dart';
import 'package:flashchatter/screens/chat_screen.dart';
import 'package:flashchatter/screens/email_auth_screen.dart';
import 'package:flashchatter/screens/forgot_password_screen.dart';
import 'package:flashchatter/screens/registration_screen.dart';
import 'package:flashchatter/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        ChatScreen.id: (context) => const ChatScreen(),
        EmailAuthScreen.id: (context) => const EmailAuthScreen(),
        ForgotPasswordScreen.id: (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
