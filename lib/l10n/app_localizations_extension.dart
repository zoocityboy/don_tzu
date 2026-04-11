import 'package:flutter/widgets.dart';
import 'package:art_of_deal_war/l10n/generated/app_localizations.dart';

extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
