import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common/components/rounded_button_field.dart';
import '../../../../../core/common/components/rounded_input_field.dart';

class ForgotPasswordPagae extends ConsumerStatefulWidget {
  const ForgotPasswordPagae({super.key});

  @override
  ConsumerState<ForgotPasswordPagae> createState() =>
      _ForgotPasswordPagaeState();
}

class _ForgotPasswordPagaeState extends ConsumerState<ForgotPasswordPagae> {
  final _emailController = TextEditingController();

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      // ignore: use_build_context_synchronously
      showDialog(
        context: context, 
        builder: (context){
          return const AlertDialog(
            title: Text('Error'),
            content: Text('Password link sent to your email'),
          );
        }
      );
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        }
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                  'Enter your email and we will send you a password reset link'),
              RoundedInputField(
                // key: const ValueKey('usernameField'),
                controller: _emailController,
                hintText: "Username",
                icon: Icons.person,
                // onChanged: (value) {},
                keyboardType: TextInputType.name,
              ),
              RoundedButton(
                text: "Reset Password",
                press: () {
                  passwordReset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
