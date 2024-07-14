import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nijaat_app/pages/Homepage/bottom_navigation_bar.dart';
import 'package:nijaat_app/pages/Homepage/drawer.dart';
import 'package:nijaat_app/pages/Homepage/first_page.dart';
import 'package:nijaat_app/pages/blog_page.dart';
import 'package:nijaat_app/pages/center_list_page.dart';
import 'package:nijaat_app/pages/events_page.dart';
import 'package:nijaat_app/pages/login_page.dart';
import 'package:nijaat_app/pages/my_apointment_page.dart';
import 'package:nijaat_app/pages/sign_up_page.dart';
import 'package:nijaat_app/pages/varify_email_page.dart';
import 'package:nijaat_app/routes/routes.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return const VerificationPage();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went out!"),
            );
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin ? LoginPage(callback: toggle) : SignupPage(callback: toggle);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const List screens = <Widget>[
    FirstPage(),
    CenterListPage(),
    Blog(),
    Events(),
    MyApointment(),
  ];
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance.collection('users');

  Widget currScreen = HomePage.screens[0];
  int selectedInBottomNav = 0;

  //for set new screens(for bottom navigation bar)
  void switchScreen(int id) {
    setState(
          () {
        currScreen = HomePage.screens[id];
        selectedInBottomNav = id;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ));
          } else if (snapshot.hasError) {
            return const Scaffold(
                body: Center(
                  child: Text("Something went worng"),
                ));
          } else {
            final userInfo = snapshot.data!.data()!;
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.aiPage),
                backgroundColor: Theme.of(context).primaryColor,
                tooltip: "Ai chat Bot",
                child: const FaIcon(
                  FontAwesomeIcons.solidMessage,
                  color: Colors.white,
                ),
              ),
              // appbar
              appBar: AppBar(
                title: const Text(
                  "NIJAAT",
                  style: TextStyle(
                      fontFamily: 'MerriweatherFont', color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),


                ),
                actions: [
                  InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.profile),
                    child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: userInfo['profile'] == null
                            ? CircleAvatar(
                          backgroundImage: const AssetImage(
                              "assets/images/profile.png"),
                          backgroundColor: Theme.of(context).primaryColor,
                        )
                            : CircleAvatar(
                          backgroundImage:
                          NetworkImage(userInfo['profile']!),
                          backgroundColor: Theme.of(context).primaryColor,
                        )),
                  )
                ],
                centerTitle: true,
                elevation: 20,
              ),
              //drawer
              drawer: MyDrawer(
                email: userInfo['email'],
                profile: userInfo['profile'],
              ),
              //Bottom Navigation Bar
              bottomNavigationBar: BottomNavigation(
                selectedItem: selectedInBottomNav,
                callback: switchScreen,
              ),
              //body
              body: currScreen,
            );
          }
        });
  }
}