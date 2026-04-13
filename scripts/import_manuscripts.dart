import 'dart:convert';
import 'dart:io';
import 'package:pocketbase/pocketbase.dart';

void main() async {
  final pb = PocketBase(
    'https://pocketbase-rb1c3qhpnzgndkkigbyd2fw0.zoocityboy.space/',
  );

  try {
    await pb.admins.authWithPassword(
      'artofdeal',
      'artofdeal2024',
    );
    print('Authenticated');
  } catch (e) {
    print('Authentication failed: $e');
    return;
  }

  final languages = ['en', 'cs', 'de', 'hu', 'pl', 'sk'];

  for (final lang in languages) {
    print('\n--- Importing $lang ---');
    await importLanguage(pb, lang);
  }

  print('\n✓ Import complete!');
  pb.close();
}

Future<void> importLanguage(PocketBase pb, String language) async {
  final file = File('assets/data/manuscripts_$language.json');

  if (!await file.exists()) {
    print('File not found: assets/data/manuscripts_$language.json');
    return;
  }

  try {
    final jsonString = await file.readAsString();
    final List<dynamic> data = json.decode(jsonString);

    int imported = 0;
    for (final item in data) {
      final record = item as Map<String, dynamic>;

      try {
        await pb
            .collection('manuscripts')
            .create(
              body: {
                'title': record['title'],
                'quote': record['quote'],
                'image': record['image'],
                'language': language,
                'order': int.parse(record['id'] as String),
              },
            );
        imported++;
        if (imported % 5 == 0) {
          print('  Imported $imported records for $language...');
        }
      } catch (e) {
        print('Error importing record ${record['id']}: $e');
      }
    }

    print('  ✓ Imported $imported records for $language');
  } catch (e) {
    print('Error reading $language: $e');
  }
}
