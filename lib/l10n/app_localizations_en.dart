// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'The Art of Deal War';

  @override
  String get introSubtitle => 'A 2500 Year Old Discovery';

  @override
  String get openTheScroll => 'OPEN THE SCROLL';

  @override
  String get storyParagraph1 =>
      'In 2024, archeologists uncovered a sealed vault in the Arizona desert containing ancient military scrolls from 250 BC.';

  @override
  String get storyParagraph2 =>
      'Among them was \"The Art of Deal War\" - a strategic military treatise written by Commander-in-Chief Don Tzu.';

  @override
  String get storyParagraph3 =>
      'Until now, these pages remained hidden from the public...';

  @override
  String get like => 'Like';

  @override
  String get liked => 'Liked';

  @override
  String get share => 'Share';

  @override
  String shareText(String title, String quote) {
    return '$title\n\n\"$quote\"\n\n— The Art of Deal War\n\nShared from The Art of Deal War app';
  }

  @override
  String get cacheCleared => 'Cache cleared!';

  @override
  String get errorLoading => 'Failed to load content';
}
