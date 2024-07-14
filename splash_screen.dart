import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nijaat_app/routes/routes.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
          () => Navigator.pushReplacementNamed(context, AppRoutes.main),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 2555),
        child: Center(
          child: Image.asset("assets/images/logo.jpg"),
        ),
      ),
    );
  }
}