import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nijaat_app/main.dart';
import 'package:nijaat_app/utils.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPage();
}

class _ResetPasswordPage extends State<ResetPasswordPage> {
  final fkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Theme.of(context).primaryColor,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Text(
                        "Forget Password?",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Don't worry! Please enter the email address linked with your account",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.35,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Form(
                      key: fkey,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10.0),
                            child: const Text(
                              "  Enter your email",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: email,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: emailValidator,
                            decoration: const InputDecoration(
                              label: Text("Email or username"),
                              labelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: textFieldFoucedBorder,
                              border: textFieldunabledBorder,
                              constraints: BoxConstraints(
                                  maxWidth: 280, maxHeight: 80, minHeight: 80),
                            ),
                          ),
                          const SizedBox(
                            height: 23,
                          ),
                          ElevatedButton(
                            onPressed: resetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 2,
                              minimumSize: const Size(280, 46),
                            ),
                            child: const Text(
                              "Reset Password",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 65,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Remember Password? ",
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pop(context)),
                        ],
                      ),
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

  Future<void> resetPassword() async {
    final isvalid = fkey.currentState!.validate();
    if (!isvalid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.text.toString().trim(),
      );
      showSnackBar("Password Reset Email Sent");
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message);
      Navigator.pop(context);
    }
  }
}