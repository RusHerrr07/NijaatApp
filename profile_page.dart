import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nijaat_app/firebase.dart';
import 'package:nijaat_app/utils.dart';

import '../model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  bool isLoading = true;
  final user = FirebaseAuth.instance.currentUser!;
  Uint8List? _image;
  bool isEnabled = false;
  TextEditingController userName = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController email = TextEditingController();
  String? downloadUrl;
  void update(UserProfile userInfo) async {
    if (isEnabled) {
      if (_image != null) {
        downloadUrl = await FirebaseServices.uploadImage(
            "users/${user.uid}/profileImage", _image!);
        userInfo.profileUrl = downloadUrl;
      }
      await FirebaseServices.updateUserTofireStore(userInfo);
      showSnackBar("Updated Sucessfully");

      setState(() {
        isEnabled = !isEnabled;
        isLoading = false;
      });
    } else {
      setState(() {
        isEnabled = !isEnabled;
        isLoading = false;
      });
    }
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
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    )
        : StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          Map<String, dynamic>? data = snapshot.data?.data();
          email.text = data?['email'];
          userName.text = data?['username'];
          phoneNo.text = data?['phoneNo'];
          address.text = data?['address'];
          dateOfBirth.text = data?['dob'];
          if (data != null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
              ),
              extendBody: true,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            _image == null
                                ? data['profile'] == null
                                ? CircleAvatar(
                              radius: 64,
                              backgroundImage: const AssetImage(
                                  "assets/images/profile.png"),
                              backgroundColor: Theme.of(context)
                                  .primaryColor,
                            )
                                : CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  data['profile']!),
                              backgroundColor: Theme.of(context)
                                  .primaryColor,
                            )
                                : CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                              backgroundColor:
                              Theme.of(context).primaryColor,
                            ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: isEnabled
                                    ? () {
                                  selectImage(context);
                                }
                                    : null,
                                icon: const Icon(Icons.add_a_photo),
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 60),
                        profileTextField(
                          hint: "Username",
                          enabled: isEnabled,
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
                          enabled: isEnabled,
                          controller: dateOfBirth,
                        ),
                        const SizedBox(height: 20),
                        profileTextField(
                          hint: "Phone no",
                          enabled: isEnabled,
                          controller: phoneNo,
                        ),
                        const SizedBox(height: 20),
                        profileTextField(
                          hint: "Address",
                          enabled: isEnabled,
                          controller: address,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            UserProfile userInfo = UserProfile(
                              email: data['email'],
                              uid: data['uid'],
                              userName: userName.text,
                              dateOfBirth: dateOfBirth.text,
                              phoneNo: phoneNo.text,
                              profileUrl: downloadUrl ?? data['profile'],
                              address: address.text,
                            );
                            update(userInfo);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).primaryColor,
                          ),
                          child: Text(isEnabled ? 'Submit' : 'Update'),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Something went worng"),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}