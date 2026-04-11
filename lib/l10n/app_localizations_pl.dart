// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Sztuka Wojny Deal';

  @override
  String get introSubtitle => 'Odkrycie sprzed 2500 lat';

  @override
  String get openTheScroll => 'OTWÓRZ ZWIJAK';

  @override
  String get storyParagraph1 =>
      'W 2024 r. archeolodzy odkryli szczelnie zamkniętą kryptę na pustyni Arizona zawierającą starożytne zwoje wojenne z 250 r. p.n.e.';

  @override
  String get storyParagraph2 =>
      'Wśród nich była \"Sztuka Wojny Deal\" - strategiczny traktat wojenny napisany przez głównodowodzącego Don Tzu.';

  @override
  String get storyParagraph3 =>
      'Do tej pory te strony pozostawały ukryte przed opinią publiczną...';

  @override
  String get like => 'Polub';

  @override
  String get liked => 'Polubione';

  @override
  String get share => 'Udostępnij';

  @override
  String shareText(String title, String quote) {
    return '$title\n\n\"$quote\"\n\n— Sztuka Wojny Deal\n\nUdostępniono z aplikacji Sztuka Wojny Deal';
  }

  @override
  String get cacheCleared => 'Pamięć podręczna wyczyszczona!';

  @override
  String get errorLoading => 'Nie udało się załadować treści';
}
