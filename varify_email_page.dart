import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:nijaat_app/firebase.dart';
import 'package:nijaat_app/model.dart';
import 'package:nijaat_app/pages/Homepage/home_page.dart';
import 'package:nijaat_app/utils.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<StatefulWidget> createState() => _VerificationPage();
}

class _VerificationPage extends State<VerificationPage> {
  TextEditingController email = TextEditingController();
  bool canResend = true;
  final User user = FirebaseAuth.instance.currentUser!;
  bool isVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    ///user needs to be created before
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isVerified) {
      sendVerificationEmail();

      //checking continouesly
      timer = Timer.periodic(
        const Duration(seconds: 3),
            (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isVerified) {
      timer?.cancel();
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    try {
      await user.sendEmailVerification();

      setState(() => canResend = false);
      await Future.delayed(const Duration(seconds: 6));
      setState(() => canResend = true);
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isVerified
        ? CheckIsFirstLogin(
      user: user,
    )
        : Material(
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
                        height: 100,
                      ),
                      Text(
                        "Verify Email",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Please verify your email to continue",
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "We have sent a varification link on ${user.email}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: canResend
                          ? () => sendVerificationEmail()
                          : () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canResend
                            ? Theme.of(context).primaryColor
                            : Colors.green.shade100,
                        elevation: 2,
                        minimumSize: const Size(280, 46),
                      ),
                      child: const Text(
                        "Resend Email",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: Theme.of(context).primaryColor),
                        backgroundColor: Theme.of(context).cardColor,
                        maximumSize: const Size(280, 60),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Resend after 5 seconds"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckIsFirstLogin extends StatelessWidget {
  final User user;
  const CheckIsFirstLogin({required this.user, super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            DocumentSnapshot doc = snapshot.data as DocumentSnapshot;
            if (doc.exists) {
              return const HomePage();
            } else {
              return const UserInfoForm();
            }
          } else {
            return const Text("Some thing went wrong");
          }
        });
  }
}

class UserInfoForm extends StatefulWidget {
  const UserInfoForm({super.key});

  @override
  State<UserInfoForm> createState() => _UserInfoForm();
}

class _UserInfoForm extends State<UserInfoForm> {
  final user = FirebaseAuth.instance.currentUser!;
  Uint8List? _image;
  TextEditingController userName = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController email = TextEditingController();
  String? downloadUrl;

  void upload(UserProfile userInfo) async {
    if (_image != null) {
      downloadUrl = await FirebaseServices.uploadImage(
          "users/${userInfo.uid}/profileImage", _image!);
      userInfo.profileUrl = downloadUrl;
    }
    await FirebaseServices.uploadUserTofireStore(userInfo);
  }

  void selectImage(BuildContext context) async {
    void callback(Uint8List? im) {
      setState(() {
        _image = im;
      });
    }

    showOptionsDialog(context, callback);
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    phoneNo.dispose();
    address.dispose();
    userName.dispose();
    dateOfBirth.dispose();
  }

  @override
  Widget build(BuildContext context) {
    email.text = user.email!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBody: true,
      body: GestureDetector(
        onTap: () {
          final currFocus = FocusScope.of(context);
          if (!currFocus.hasPrimaryFocus) {
            currFocus.unfocus();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      _image == null
                          ? CircleAvatar(
                        radius: 64,
                        backgroundImage:
                        const AssetImage("assets/images/profile.png"),
                        backgroundColor: Theme.of(context).primaryColor,
                      )
                          : CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () => selectImage(context),
                          icon: const Icon(Icons.add_a_photo),
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 60),
                  profileTextField(
                    hint: "Username",
                    enabled: true,
                    controller: userName,
                  ),
                  const SizedBox(height: 20),
                  profileTextField(
                    hint: "Email",
                    enabled: false,
                    controller: email,
                  ),
                  const SizedBox(height: 20),
                  profileTextField(
                    hint: "D.O.B.",
                    enabled: true,
                    controller: dateOfBirth,
                  ),
                  const SizedBox(height: 20),
                  profileTextField(
                    hint: "Phone no",
                    enabled: true,
                    controller: phoneNo,
                  ),
                  const SizedBox(height: 20),
                  profileTextField(
                    hint: "Address",
                    enabled: true,
                    controller: address,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      skipbutton,
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: () {
                          UserProfile userInfo = UserProfile(
                            email: user.email!,
                            uid: user.uid,
                            userName: userName.text,
                            dateOfBirth: dateOfBirth.text,
                            phoneNo: phoneNo.text,
                            profileUrl: downloadUrl ?? user.photoURL,
                            address: address.text,
                          );
                          upload(userInfo);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

OutlinedButton skipbutton = OutlinedButton(
  child: const Center(child: Text("Skip")),
  onPressed: () {
    User user = FirebaseAuth.instance.currentUser!;
    UserProfile userProfile = UserProfile(
      email: user.email!,
      uid: user.uid,
      userName: user.displayName,
      dateOfBirth: "",
      phoneNo: user.phoneNumber ?? "",
      profileUrl: user.photoURL,
      address: "",
    );
    FirebaseServices.uploadUserTofireStore(userProfile);
  },
);