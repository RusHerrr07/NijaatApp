import 'package:flutter/material.dart';

class MyApointment extends StatelessWidget {
  const MyApointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: const Color.fromARGB(189, 196, 236, 198),
        child: const Center(
          child: Text("my appointment"),
        ),
      ),
    );
  }
}