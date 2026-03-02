import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/entry.dart';

// A single card shown in the feed for one Entry.
// Stage 1: style this card — change fonts, colors, spacing.
// Stage 4: add tag chips below the text.
// Stage 5 Track A: add a photo thumbnail at the top.
class EntryCard extends StatelessWidget {
  final Entry entry;

  const EntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              entry.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            // Date — formatted with intl package
            Text(
              DateFormat('dd MMM yyyy').format(entry.date),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            // Text preview — capped at 3 lines
            Text(
              entry.text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            // TODO Stage 4: Display entry.tags as Chip widgets inside a Wrap
            // Example:
            //   if (entry.tags.isNotEmpty) ...[
            //     const SizedBox(height: 8),
            //     Wrap(
            //       spacing: 4,
            //       children: entry.tags.map((tag) => Chip(label: Text(tag))).toList(),
            //     ),
            //   ]
          ],
        ),
      ),
    );
  }
}
