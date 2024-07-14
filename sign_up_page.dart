import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nijaat_app/firebase.dart';
import 'package:nijaat_app/main.dart';
import 'package:nijaat_app/utils.dart';

class SignupPage extends StatefulWidget {
  final void Function() callback;
  const SignupPage({required this.callback, super.key});

  @override
  State<SignupPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignupPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();
  final fkey = GlobalKey<FormState>();
  bool show = false;
  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    cpassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currFocus = FocusScope.of(context);
        if (!currFocus.hasPrimaryFocus) {
          currFocus.unfocus();
        }
      },
      child: Material(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 1.15,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 1.15,
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
                          "Welcome in ",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Nasha Mukt Bharat App",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.1,
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
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                          "   Sign up",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: fkey,
                        child: Column(
                          children: [
                            TextFormField(
                              // onTapOutside: (event) {
                              //   FocusScope.of(context).unfocus();
                              // },
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
                                    maxWidth: 280, maxHeight: 80),
                              ),
                            ),
                            const SizedBox(
                              height: 23,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !show,
                              controller: password,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: passwordValidator,
                              decoration: InputDecoration(
                                label: const Text("Password"),
                                labelStyle: const TextStyle(color: Colors.grey),
                                focusedBorder: textFieldFoucedBorder,
                                border: textFieldunabledBorder,
                                constraints: const BoxConstraints(
                                    maxWidth: 280, maxHeight: 80),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                    icon: Icon(show
                                        ? FontAwesomeIcons.solidEye
                                        : FontAwesomeIcons.solidEyeSlash),
                                    onPressed: () {
                                      setState(() {
                                        show = !show;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              controller: cpassword,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                              value == null && value == password.text
                                  ? "Not match with password"
                                  : null,
                              decoration: const InputDecoration(
                                label: Text("Comfirm Password"),
                                labelStyle: TextStyle(color: Colors.grey),
                                focusedBorder: textFieldFoucedBorder,
                                border: textFieldunabledBorder,
                                constraints: BoxConstraints(
                                    maxWidth: 280, maxHeight: 80),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: pressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                elevation: 2,
                                minimumSize: const Size(280, 46),
                              ),
                              child: const Text(
                                "Sign up",
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
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1,
                            width: 80,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Or, Signup with',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 1,
                            width: 80,
                            color: Theme.of(context).disabledColor,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          await FirebaseServices.signInWithGoogle();
                        },
                        style: OutlinedButton.styleFrom(
                          side:
                          BorderSide(color: Theme.of(context).primaryColor),
                          backgroundColor: Theme.of(context).cardColor,
                          maximumSize: const Size(280, 50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.google,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Continue with Google",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account?",
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.callback,
                            ),
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
      ),
    );
  }

  void pressed() {
    final bool isvalid = fkey.currentState!.validate();
    if (!isvalid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    FirebaseServices.signup(email.text.trim(), password.text.trim());
    navigatorKey.currentState!.pop();
  }
}