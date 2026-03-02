import 'package:flutter/material.dart';
import '../models/entry.dart';
// TODO Stage 1: Uncomment the line below to use the sample data
// import '../data/sample_entries.dart';
import '../widgets/entry_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // This list holds all entries shown in the feed.
  // TODO Stage 1: Replace the empty list with sampleEntries to see sample cards.
  final List<Entry> _entries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Cards'),
        // TODO Stage 1: Explore AppBar's 'actions' parameter to add a button here
      ),
      body: _entries.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_stories_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No memories yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to create your first one!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                return EntryCard(entry: _entries[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO Stage 2: Navigate to CreateEntryScreen and get back a new Entry.
          // Example:
          //   final newEntry = await Navigator.push<Entry>(
          //     context,
          //     MaterialPageRoute(builder: (_) => const CreateEntryScreen()),
          //   );
          //   if (newEntry != null) {
          //     setState(() => _entries.insert(0, newEntry));
          //   }
        },
        tooltip: 'Add memory',
        child: const Icon(Icons.add),
      ),
    );
  }
}
