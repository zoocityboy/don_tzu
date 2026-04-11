// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Art of Deal War';

  @override
  String get introSubtitle => '2500 let starý objev';

  @override
  String get openTheScroll => 'OTEVŘÍT SVITEK';

  @override
  String get storyParagraph1 =>
      'V roce 2024 archeologové objevili utajenou kryptu v arizonské poušti obsahující starověké vojenské svitky z roku 250 př.n.l.';

  @override
  String get storyParagraph2 =>
      'Mezi nimi bylo \"Art of Deal War\" - strategický vojenský spis sepsaný velitelem Don Tzu.';

  @override
  String get storyParagraph3 =>
      'Až dosud tyto stránky zůstávaly skryty před veřejností...';

  @override
  String get like => 'Líbit se';

  @override
  String get liked => 'Líbí se';

  @override
  String get share => 'Sdílet';

  @override
  String shareText(String title, String quote) {
    return '$title\n\n\"$quote\"\n\n— Art of Deal War\n\nSdíleno z aplikace Art of Deal War';
  }

  @override
  String get cacheCleared => 'Mezipaměť vymazána!';

  @override
  String get errorLoading => 'Nepodařilo se načíst obsah';
}
