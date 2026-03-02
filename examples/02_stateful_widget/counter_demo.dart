// EXAMPLE 02 — StatefulWidget and setState
//
// Key concepts:
//   - StatefulWidget: a widget that can change over time
//   - setState(): tells Flutter to rebuild the widget with new values
//   - initState(): called once when the widget is first created
//   - dispose(): called when the widget is removed (cleanup)
//
// This example has TWO demos:
//   1. A color box that changes color on tap
//   2. A text field that shows a live character count

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StatefulDemoScreen(),
    );
  }
}

class StatefulDemoScreen extends StatefulWidget {
  const StatefulDemoScreen({super.key});

  @override
  State<StatefulDemoScreen> createState() => _StatefulDemoScreenState();
}

class _StatefulDemoScreenState extends State<StatefulDemoScreen> {
  // ── Demo 1 state ──────────────────────────────────────────────────────────
  // This is the state — it lives between rebuilds.
  // When it changes (via setState), Flutter redraws the widget.
  int _tapCount = 0;

  static const _colors = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  Color get _currentColor => _colors[_tapCount % _colors.length];

  // ── Demo 2 state ──────────────────────────────────────────────────────────
  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;

  // initState: called ONCE when the widget is first inserted.
  // Use it to set up state that depends on something (here: listening to the controller).
  @override
  void initState() {
    super.initState(); // Always call super first
    _controller.addListener(() {
      // Whenever the text changes, update _charCount and rebuild
      setState(() {
        _charCount = _controller.text.length;
      });
    });
  }

  // dispose: called when the widget is removed from the tree.
  // Always dispose controllers to prevent memory leaks.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose(); // Always call super last
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StatefulWidget Demo')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Demo 1: Tap to change color ───────────────────────────────
            const Text('Demo 1: tap the box to change its color',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // setState() is the KEY — without it, the color changes in memory
                // but Flutter doesn't know to redraw the screen.
                setState(() {
                  _tapCount++;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: _currentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Tapped $_tapCount time${_tapCount == 1 ? '' : 's'}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Demo 2: Live character count ──────────────────────────────
            const Text('Demo 2: live character count',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Type something...',
                // suffixText updates automatically because setState is called on every keystroke
                suffixText: '$_charCount chars',
              ),
            ),
            const SizedBox(height: 8),
            // This text also rebuilds when setState is called
            Text(
              _charCount == 0
                  ? 'Start typing!'
                  : _charCount < 10
                      ? 'Keep going...'
                      : 'Looking good! 👍',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
