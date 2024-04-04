import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Starting from here...",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
