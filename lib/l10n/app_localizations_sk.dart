// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get appTitle => 'Umenie Deal War';

  @override
  String get introSubtitle => '2500 rokov starý objav';

  @override
  String get openTheScroll => 'OTVORIŤ ZVÍJAK';

  @override
  String get storyParagraph1 =>
      'V roku 2024 archeológovia objavili zapečatenú kryptu v arizonskej púšti obsahujúcu staroveké vojenské zvitky z roku 250 pred n.l.';

  @override
  String get storyParagraph2 =>
      'Medzi nimi bolo \"Umenie Deal War\" - strategický vojenský spis napísaný hlavným veliteľom Don Tzu.';

  @override
  String get storyParagraph3 =>
      'Až doteraz tieto stránky zostávali skryté pred verejnosťou...';

  @override
  String get like => 'Páči sa';

  @override
  String get liked => 'Páči sa';

  @override
  String get share => 'Zdieľať';

  @override
  String shareText(String title, String quote) {
    return '$title\n\n\"$quote\"\n\n— Umenie Deal War\n\nZdieľané z aplikácie Umenie Deal War';
  }

  @override
  String get cacheCleared => 'Medzipamäť vymazaná!';

  @override
  String get errorLoading => 'Nepodarilo sa načítať obsah';
}
