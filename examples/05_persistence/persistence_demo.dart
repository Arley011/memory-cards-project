// EXAMPLE 05 — SharedPreferences (local persistence)
//
// Key concepts:
//   - SharedPreferences: a simple key-value store that persists across app restarts
//   - getStringList / setStringList: store a list of strings
//   - initState: load saved data when the screen first appears
//   - async / await: working with futures (data that arrives "later")
//
// Try it: add some words, close the app, reopen it — the words are still there!

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersistenceDemoScreen(),
    );
  }
}

class PersistenceDemoScreen extends StatefulWidget {
  const PersistenceDemoScreen({super.key});

  @override
  State<PersistenceDemoScreen> createState() => _PersistenceDemoScreenState();
}

class _PersistenceDemoScreenState extends State<PersistenceDemoScreen> {
  // The key used to store and load the data.
  // Think of SharedPreferences like a Map<String, dynamic> saved on the device.
  static const _storageKey = 'favourite_words';

  List<String> _words = [];
  final _controller = TextEditingController();
  bool _isLoading = true; // Show a spinner while loading

  @override
  void initState() {
    super.initState();
    _loadWords(); // Load saved words when the screen is created
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Load ─────────────────────────────────────────────────────────────────

  Future<void> _loadWords() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_storageKey) ?? []; // [] if nothing saved yet
    setState(() {
      _words = saved;
      _isLoading = false;
    });
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> _saveWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _words);
  }

  // ── Add a word ────────────────────────────────────────────────────────────

  void _addWord() {
    final word = _controller.text.trim();
    if (word.isEmpty) return;
    setState(() {
      _words.add(word);
      _controller.clear();
    });
    _saveWords(); // Save after every change
  }

  // ── Remove a word ─────────────────────────────────────────────────────────

  void _removeWord(int index) {
    setState(() => _words.removeAt(index));
    _saveWords(); // Save after every change
  }

  // ── Clear all ─────────────────────────────────────────────────────────────

  Future<void> _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey); // Completely removes the key
    setState(() => _words.clear());
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BONUS: Storing an object (not just a string)
  //
  // SharedPreferences can only store simple types: String, int, bool, List<String>.
  // To store an object, convert it to JSON first:
  //
  //   Map<String, dynamic> data = {'name': 'Alice', 'age': 30};
  //   String jsonString = jsonEncode(data);   // → '{"name":"Alice","age":30}'
  //   await prefs.setString('my_object', jsonString);
  //
  //   String? saved = prefs.getString('my_object');
  //   if (saved != null) {
  //     Map<String, dynamic> restored = jsonDecode(saved);
  //   }
  //
  // For a list of objects, store a List<String> where each string is a JSON object:
  //   final jsonList = objects.map((o) => jsonEncode(o.toJson())).toList();
  //   await prefs.setStringList('items', jsonList);
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistence Demo'),
        actions: [
          if (_words.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear all',
              onPressed: _clearAll,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ── Input row ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter a word...',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _addWord(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addWord,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),

                // ── Saved word list ────────────────────────────────────
                Expanded(
                  child: _words.isEmpty
                      ? const Center(
                          child: Text(
                            'No words saved yet.\nAdd some and restart the app!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _words.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text(_words[index]),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _removeWord(index),
                              ),
                            );
                          },
                        ),
                ),

                // ── Hint at the bottom ─────────────────────────────────
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Close and reopen the app — your words will still be here!',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
    );
  }
}
