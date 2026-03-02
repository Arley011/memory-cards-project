// EXAMPLE 06 — List CRUD (Add, Delete, Dismiss)
//
// Key concepts:
//   - Adding items to a List with setState
//   - Removing items by index
//   - Dismissible: swipe-to-delete widget
//   - showDialog / AlertDialog: confirmation before delete
//   - Key: why list items need unique keys

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListCrudDemoScreen(),
    );
  }
}

class ListCrudDemoScreen extends StatefulWidget {
  const ListCrudDemoScreen({super.key});

  @override
  State<ListCrudDemoScreen> createState() => _ListCrudDemoScreenState();
}

class _ListCrudDemoScreenState extends State<ListCrudDemoScreen> {
  final _controller = TextEditingController();

  // The list of items. Each item is a simple String for this demo.
  // In the real app, this would be List<Entry>.
  final List<String> _items = [
    'Buy groceries',
    'Call mum',
    'Learn Flutter',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Add ────────────────────────────────────────────────────────────────

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _items.insert(0, text); // Insert at top of list
      _controller.clear();
    });
  }

  // ── Delete with confirmation dialog ───────────────────────────────────

  Future<void> _deleteItem(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('"${_items[index]}"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false), // User chose Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), // User chose Delete
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _items.removeAt(index));
      // Show brief feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items (${_items.length})'),
      ),
      body: Column(
        children: [
          // ── Input row ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'New item...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),

          // ── Item list ─────────────────────────────────────────────────
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('No items! Add one above.'))
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      // Dismissible enables swipe-to-delete.
                      // The 'key' MUST be unique — Flutter uses it to track
                      // which widget to remove during the swipe animation.
                      return Dismissible(
                        key: ValueKey(_items[index] + index.toString()),
                        direction: DismissDirection.endToStart, // swipe left
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          // Called after the swipe animation completes.
                          // The item is already visually gone — just update state.
                          final removed = _items[index];
                          setState(() => _items.removeAt(index));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"$removed" deleted'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  // Re-insert the item at its original position
                                  setState(() => _items.insert(index, removed));
                                },
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(_items[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Delete with confirmation',
                            onPressed: () => _deleteItem(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ── Legend ────────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Swipe left to delete instantly  •  Tap 🗑 for confirmation dialog',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
