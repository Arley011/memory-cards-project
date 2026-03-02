// EXAMPLE 03 — Navigation between screens
//
// Files in this example:
//   main.dart    — App entry point (this file)
//   screen_a.dart — First screen, navigates to Screen B
//   screen_b.dart — Second screen, returns a value when closed
//
// Key concepts:
//   - Navigator.push: go to a new screen
//   - Navigator.pop: go back, optionally returning a value
//   - await: wait for the second screen to close and get its result
//   - MaterialPageRoute: the standard slide-in transition

import 'package:flutter/material.dart';
import 'screen_a.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenA(),
    );
  }
}
