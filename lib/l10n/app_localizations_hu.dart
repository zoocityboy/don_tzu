// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'A Deal Háború Művészete';

  @override
  String get introSubtitle => '2500 éves felfedezés';

  @override
  String get openTheScroll => 'TEKERCSET NYITNI';

  @override
  String get storyParagraph1 =>
      '2024-ben régészek feltártak egy lezárt széfet az arizónai sivatagban, amely ókori katonai tekercseket tartalmazott i.e. 250-ből.';

  @override
  String get storyParagraph2 =>
      'Közöttük volt \"A Deal Háború Művészete\" - egy stratégiai katonai értekezés, amelyet Főparancsnok Don Tzu írt.';

  @override
  String get storyParagraph3 =>
      'Eddig ezek az oldalak rejtve maradtak a nyilvánosság előtt...';

  @override
  String get like => 'Tetszik';

  @override
  String get liked => 'Tetszik';

  @override
  String get share => 'Megosztás';

  @override
  String shareText(String title, String quote) {
    return '$title\n\n\"$quote\"\n\n— A Deal Háború Művészete\n\nMegosztva a Deal Háború Művészete alkalmazásból';
  }

  @override
  String get cacheCleared => 'Gyorsítótár törölve!';

  @override
  String get errorLoading => 'A tartalom betöltése sikertelen';
}
