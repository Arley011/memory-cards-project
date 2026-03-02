// Screen A — opens Screen B and receives a value back

import 'package:flutter/material.dart';
import 'screen_b.dart';

class ScreenA extends StatefulWidget {
  const ScreenA({super.key});

  @override
  State<ScreenA> createState() => _ScreenAState();
}

class _ScreenAState extends State<ScreenA> {
  // This stores the message returned from Screen B.
  String _result = 'Nothing yet — open Screen B!';

  Future<void> _goToScreenB() async {
    // Navigator.push opens a new screen.
    // We use 'await' so this function pauses here until Screen B is closed.
    // The generic type <String?> means Screen B can return a String (or null).
    final returnedValue = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ScreenB()),
    );

    // When we reach this line, Screen B has been closed.
    // returnedValue is whatever Screen B passed to Navigator.pop().
    // It can be null if the user pressed the system back button.
    if (returnedValue != null) {
      setState(() => _result = returnedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen A')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is Screen A.', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Message from Screen B:\n"$_result"',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _goToScreenB,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Open Screen B'),
            ),
          ],
        ),
      ),
    );
  }
}
