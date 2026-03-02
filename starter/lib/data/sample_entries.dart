import '../models/entry.dart';

// These are hardcoded example entries used in Stage 1 to populate the feed.
// In Stage 3 you will replace them with real entries loaded from storage.

const List<String> availableTags = [
  'Travel',
  'Food',
  'Erasmus',
  'Ideas',
  'Culture',
  'Other',
];

final List<Entry> sampleEntries = [
  Entry(
    id: '1',
    title: 'Arrived at Gut Wehlitz',
    text: 'What a journey! Trains, buses, and finally here. '
        'The mansion is huge and surrounded by fields. '
        'My room has a view of the garden — not bad for a week of coding.',
    date: DateTime(2025, 9, 1),
    tags: ['Travel', 'Erasmus'],
  ),
  Entry(
    id: '2',
    title: 'First German breakfast',
    text: 'Bread, cheese, cold cuts — very different from home. '
        'Actually really good. The coffee here is strong.',
    date: DateTime(2025, 9, 2),
    tags: ['Food'],
  ),
  Entry(
    id: '3',
    title: 'Leipzig city trip',
    text: 'Took the train to Leipzig with the group. '
        'The old town is beautiful. We visited Thomaskirche '
        'and had ice cream near the Marktplatz.',
    date: DateTime(2025, 9, 3),
    tags: ['Travel', 'Culture'],
  ),
  Entry(
    id: '4',
    title: 'Flutter is hard',
    text: 'Spent 2 hours on one widget. But when it finally worked, '
        'it felt amazing. Small wins.',
    date: DateTime(2025, 9, 4),
    tags: ['Ideas'],
  ),
  Entry(
    id: '5',
    title: 'Cycling around Schkeuditz',
    text: 'Borrowed bikes and explored the town after class. '
        'Found a small bakery with the best Kuchen. '
        'The flat roads here make cycling so easy.',
    date: DateTime(2025, 9, 5),
    tags: ['Travel'],
  ),
  Entry(
    id: '6',
    title: 'Cooking together',
    text: 'Everyone made a dish from their country tonight. '
        'So much food! We ate in the big kitchen at Gut Wehlitz. '
        'I think the Turkish group won this round.',
    date: DateTime(2025, 9, 6),
    tags: ['Food', 'Erasmus'],
  ),
  Entry(
    id: '7',
    title: 'First app running!',
    text: 'My app actually works on the phone now. '
        'I can scroll through cards and everything looks clean. '
        'Showed it to my roommate — they want to learn Flutter too.',
    date: DateTime(2025, 9, 7),
    tags: ['Ideas', 'Erasmus'],
  ),
];
