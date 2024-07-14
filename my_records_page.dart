import 'package:flutter/material.dart';

class MyRecords extends StatelessWidget {
  const MyRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: const Color.fromARGB(189, 196, 236, 198),
        child: const Center(
          child: Text("my record"),
        ),
      ),
    );
  }
}