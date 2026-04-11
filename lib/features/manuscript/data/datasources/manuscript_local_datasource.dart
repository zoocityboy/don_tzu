import 'package:art_of_deal_war/features/manuscript/data/models/manuscript_page_model.dart';

abstract class ManuscriptLocalDataSource {
  Future<Set<String>> getLikedPageIds();
  Future<List<ManuscriptPageModel>> getManuscriptPages();
  Future<void> saveLikedPageIds(Set<String> ids);
}

class ManuscriptLocalDataSourceImpl implements ManuscriptLocalDataSource {
  // Sample satirical manuscript content - new quotes
  static final List<ManuscriptPageModel> _samplePages = [
    ManuscriptPageModel(
      id: '1',
      title: 'Chapter I - Total Victory',
      quote:
          'The goal is total victory, and we are going to win so much you will get tired of winning. Many people are saying it.',
      imageAsset: 'assets/images/1.webp',
    ),
    ManuscriptPageModel(
      id: '2',
      title: 'Chapter II - Know Your Enemy',
      quote:
          'Always know your enemy, especially the fake news media, for they are unfair to a tremendous degree.',
      imageAsset: 'assets/images/2.webp',
    ),
    ManuscriptPageModel(
      id: '3',
      title: 'Chapter III - Strong Commander',
      quote:
          'A wise commander keeps his troops strong with the best equipment and the highest pay, maybe ever.',
      imageAsset: 'assets/images/3.webp',
    ),
    ManuscriptPageModel(
      id: '4',
      title: 'Chapter IV - The Wall',
      quote:
          'Build a wall. A tremendously hugest wall. It keeps the bad hombres out and makes the neighbor pay for it.',
      imageAsset: 'assets/images/4.webp',
    ),
    ManuscriptPageModel(
      id: '5',
      title: 'Chapter V - Stable General',
      quote:
          'The stable general has a very good brain, maybe the best brain in the entire army, believe me.',
      imageAsset: 'assets/images/5.webp',
    ),
    ManuscriptPageModel(
      id: '6',
      title: 'Chapter VI - Greatest Deal',
      quote:
          'When you make a deal, make the greatest deal in history. Otherwise, you are a loser, and no one likes a loser.',
      imageAsset: 'assets/images/6.webp',
    ),
    ManuscriptPageModel(
      id: '7',
      title: 'Chapter VII - Ignore Haters',
      quote:
          'Criticism is the food of haters. Pay no attention to them. They are just total disasters.',
      imageAsset: 'assets/images/7.webp',
    ),
    ManuscriptPageModel(
      id: '8',
      title: 'Chapter VIII - Counter-Punch',
      quote:
          'If attacked on social media, use your words—the best, most tremendous words—to counter-punch with overwhelming force at 3 AM.',
      imageAsset: 'assets/images/8.webp',
    ),
    ManuscriptPageModel(
      id: '9',
      title: 'Chapter IX - Overwhelming Strength',
      quote:
          'To avoid war, be so strong that nobody would even dream of attacking you. We are talking about overwhelming, unbelievable strength.',
      imageAsset: 'assets/images/9.webp',
    ),
    ManuscriptPageModel(
      id: '10',
      title: 'Chapter X - Foreign Commanders',
      quote:
          'Do not trust the foreign commanders, for they are killing us on trade and stealing our jobs. They are not nice people.',
      imageAsset: 'assets/images/10.webp',
    ),
    ManuscriptPageModel(
      id: '11',
      title: 'Chapter XI - Draw a Crowd',
      quote:
          'A true leader knows how to draw a crowd, and a bigger crowd is always a sign of a better commander, period.',
      imageAsset: 'assets/images/11.webp',
    ),
    ManuscriptPageModel(
      id: '12',
      title: 'Chapter XII - Fake Terrain',
      quote:
          'If the ground is not to your liking, declare it fake terrain and claim you meant to be somewhere else.',
      imageAsset: 'assets/images/12.webp',
    ),
    ManuscriptPageModel(
      id: '13',
      title: 'Chapter XIII - Greatest Idea',
      quote:
          'When you have an idea, ensure everyone knows it is your idea, because it is the single greatest idea anyone has ever had.',
      imageAsset: 'assets/images/13.webp',
    ),
    ManuscriptPageModel(
      id: '14',
      title: 'Chapter XIV - Save Strength',
      quote:
          'Avoid small, unnecessary skirmishes. Save your strength for the big rallies and the huge deals.',
      imageAsset: 'assets/images/14.webp',
    ),
    ManuscriptPageModel(
      id: '15',
      title: 'Chapter XV - Powerful Handshake',
      quote:
          'When diplomats fail, use a powerful, tremendous handshake to show them who is the strongest, believe me.',
      imageAsset: 'assets/images/15.webp',
    ),
    ManuscriptPageModel(
      id: '16',
      title: 'Chapter XVI - Fine People',
      quote:
          'In times of conflict, remember that there are very fine people on both sides, as long as one side is not the fake news media.',
      imageAsset: 'assets/images/16.webp',
    ),
    ManuscriptPageModel(
      id: '17',
      title: 'Chapter XVII - Drain the Swamp',
      quote:
          'When a general is corrupt, you must drain the swamp, because nobody has drained swamps better than me.',
      imageAsset: 'assets/images/17.webp',
    ),
    ManuscriptPageModel(
      id: '18',
      title: 'Chapter XVIII - Ignore Rules',
      quote:
          'Sometimes, strategy means admitting that the rules are unfair and just ignoring them to win. This is common sense.',
      imageAsset: 'assets/images/18.webp',
    ),
    ManuscriptPageModel(
      id: '19',
      title: 'Chapter XIX - Great Brand',
      quote:
          'A truly great commander is a brand, a tremendous, very strong, very powerful brand.',
      imageAsset: 'assets/images/19.webp',
    ),
    ManuscriptPageModel(
      id: '20',
      title: 'Chapter XX - Stable Genius',
      quote:
          'Do not question the wise leader\'s intelligence, because he is a very stable genius.',
      imageAsset: 'assets/images/20.webp',
    ),
  ];

  @override
  Future<Set<String>> getLikedPageIds() async {
    return {};
  }

  @override
  Future<List<ManuscriptPageModel>> getManuscriptPages() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _samplePages;
  }

  @override
  Future<void> saveLikedPageIds(Set<String> ids) async {
    // No-op for now
  }
}
