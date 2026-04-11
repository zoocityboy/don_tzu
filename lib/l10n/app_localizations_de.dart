// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Die Kunst des Deal-Kriegs';

  @override
  String get introSubtitle => 'Eine 2500 Jahre alte Entdeckung';

  @override
  String get openTheScroll => 'SCROLL ÖFFNEN';

  @override
  String get storyParagraph1 =>
      'Im Jahr 2024 entdeckten Archäologen ein versiegeltes Gewölbe in der Arizona-Wüste, das antike Militärschriften aus dem Jahr 250 v. Chr. enthielt.';

  @override
  String get storyParagraph2 =>
      'Darunter war \"Die Kunst des Deal-Kriegs\" - eine strategische Militärabhandlung, verfasst von Oberbefehlshaber Don Tzu.';

  @override
  String get storyParagraph3 =>
      'Bis heute blieben diese Seiten vor der Öffentlichkeit verborgen...';

  @override
  String get like => 'Gefällt mir';

  @override
  String get liked => 'Gefällt mir';

  @override
  String get share => 'Teilen';

  @override
  String shareText(String title, String quote) {
    return '$title\n\n\"$quote\"\n\n— Die Kunst des Deal-Kriegs\n\nGeteilt aus der App Die Kunst des Deal-Kriegs';
  }

  @override
  String get cacheCleared => 'Cache geleert!';

  @override
  String get errorLoading => 'Inhalt konnte nicht geladen werden';
}
