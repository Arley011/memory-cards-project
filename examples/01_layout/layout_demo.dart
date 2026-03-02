// EXAMPLE 01 — Layout basics
//
// This file shows how to use the most common layout widgets in Flutter.
// It builds a mock "memory card" using only layout primitives.
//
// How to use: Copy the content of MyApp into your lib/main.dart to run it.

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(title: const Text('Layout Demo')),
        body: const LayoutDemoScreen(),
      ),
    );
  }
}

class LayoutDemoScreen extends StatelessWidget {
  const LayoutDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16), // Space around the whole list
      children: const [
        _SectionTitle('Column — stacks children vertically'),
        _ColumnExample(),

        SizedBox(height: 24), // Fixed vertical gap between sections

        _SectionTitle('Row — places children horizontally'),
        _RowExample(),

        SizedBox(height: 24),

        _SectionTitle('Card — a raised container'),
        _CardExample(),

        SizedBox(height: 24),

        _SectionTitle('Wrap — like Row but wraps to next line'),
        _WrapExample(),
      ],
    );
  }
}

// ─── Column ──────────────────────────────────────────────────────────────────

class _ColumnExample extends StatelessWidget {
  const _ColumnExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        // crossAxisAlignment controls horizontal alignment of children
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Title',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4), // Small vertical gap
          const Text(
            '01 Sep 2025',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          const Text(
            'Some body text that describes the memory in more detail.',
          ),
        ],
      ),
    );
  }
}

// ─── Row ─────────────────────────────────────────────────────────────────────

class _RowExample extends StatelessWidget {
  const _RowExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Row: title on left, date on right
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Push children apart
            children: const [
              Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '01 Sep 2025',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row: icon + text together
          Row(
            children: const [
              Icon(Icons.label_outline, size: 16, color: Colors.purple),
              SizedBox(width: 4), // Horizontal gap
              Text('Travel'),
              SizedBox(width: 8),
              Icon(Icons.label_outline, size: 16, color: Colors.orange),
              SizedBox(width: 4),
              Text('Food'),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _CardExample extends StatelessWidget {
  const _CardExample();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Shadow depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Berlin arrival',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('01 Sep', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Finally here! The airport was huge and I almost missed the train.',
              maxLines: 2,
              overflow:
                  TextOverflow.ellipsis, // Shows "..." when text is too long
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Wrap ─────────────────────────────────────────────────────────────────────

class _WrapExample extends StatelessWidget {
  const _WrapExample();

  @override
  Widget build(BuildContext context) {
    const tags = ['Travel', 'Food', 'Erasmus', 'Ideas', 'Culture', 'Other'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8, // Horizontal gap between chips
        runSpacing: 8, // Vertical gap between rows
        children: tags.map((tag) => Chip(label: Text(tag))).toList(),
      ),
    );
  }
}

// ─── Helper ───────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
    );
  }
}
