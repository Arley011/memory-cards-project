// Screen B — shows a form and returns the result to Screen A

import 'package:flutter/material.dart';

class ScreenB extends StatefulWidget {
  const ScreenB({super.key});

  @override
  State<ScreenB> createState() => _ScreenBState();
}

class _ScreenBState extends State<ScreenB> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // Always dispose controllers
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Navigator.pop closes this screen.
    // The second argument is the value we want to send back to Screen A.
    // Screen A receives it from the 'await Navigator.push(...)' call.
    Navigator.pop(context, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen B'),
        // The back button in the AppBar calls Navigator.pop(context)
        // without a value — Screen A will receive null.
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Type a message to send back to Screen A:',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Your message...',
              ),
              autofocus: true,
              onSubmitted: (_) => _send(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _send,
              icon: const Icon(Icons.send),
              label: const Text('Send to Screen A'),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Pressing the back button or the AppBar back arrow '
              'also closes this screen, but returns null to Screen A.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
