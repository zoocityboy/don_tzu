import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'manuscript_localizations_cs.dart';
import 'manuscript_localizations_de.dart';
import 'manuscript_localizations_en.dart';
import 'manuscript_localizations_hu.dart';
import 'manuscript_localizations_pl.dart';
import 'manuscript_localizations_sk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ManuscriptLocalizations
/// returned by `ManuscriptLocalizations.of(context)`.
///
/// Applications need to include `ManuscriptLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/manuscript_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ManuscriptLocalizations.localizationsDelegates,
///   supportedLocales: ManuscriptLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the ManuscriptLocalizations.supportedLocales
/// property.
abstract class ManuscriptLocalizations {
  ManuscriptLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ManuscriptLocalizations? of(BuildContext context) {
    return Localizations.of<ManuscriptLocalizations>(context, ManuscriptLocalizations);
  }

  static const LocalizationsDelegate<ManuscriptLocalizations> delegate = _ManuscriptLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('hu'),
    Locale('pl'),
    Locale('sk')
  ];

  /// No description provided for @manuscriptChapter1Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter I - Total Victory'**
  String get manuscriptChapter1Title;

  /// No description provided for @manuscriptChapter1Quote.
  ///
  /// In en, this message translates to:
  /// **'The goal is total victory, and we are going to win so much you will get tired of winning. Many people are saying it.'**
  String get manuscriptChapter1Quote;

  /// No description provided for @manuscriptChapter2Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter II - Know Your Enemy'**
  String get manuscriptChapter2Title;

  /// No description provided for @manuscriptChapter2Quote.
  ///
  /// In en, this message translates to:
  /// **'Always know your enemy, especially the fake news media, for they are unfair to a tremendous degree.'**
  String get manuscriptChapter2Quote;

  /// No description provided for @manuscriptChapter3Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter III - Strong Commander'**
  String get manuscriptChapter3Title;

  /// No description provided for @manuscriptChapter3Quote.
  ///
  /// In en, this message translates to:
  /// **'A wise commander keeps his troops strong with the best equipment and the highest pay, maybe ever.'**
  String get manuscriptChapter3Quote;

  /// No description provided for @manuscriptChapter4Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter IV - The Wall'**
  String get manuscriptChapter4Title;

  /// No description provided for @manuscriptChapter4Quote.
  ///
  /// In en, this message translates to:
  /// **'Build a wall. A tremendously hugest wall. It keeps the bad hombres out and makes the neighbor pay for it.'**
  String get manuscriptChapter4Quote;

  /// No description provided for @manuscriptChapter5Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter V - Stable General'**
  String get manuscriptChapter5Title;

  /// No description provided for @manuscriptChapter5Quote.
  ///
  /// In en, this message translates to:
  /// **'The stable general has a very good brain, maybe the best brain in the entire army, believe me.'**
  String get manuscriptChapter5Quote;

  /// No description provided for @manuscriptChapter6Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter VI - Greatest Deal'**
  String get manuscriptChapter6Title;

  /// No description provided for @manuscriptChapter6Quote.
  ///
  /// In en, this message translates to:
  /// **'When you make a deal, make the greatest deal in history. Otherwise, you are a loser, and no one likes a loser.'**
  String get manuscriptChapter6Quote;

  /// No description provided for @manuscriptChapter7Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter VII - Ignore Haters'**
  String get manuscriptChapter7Title;

  /// No description provided for @manuscriptChapter7Quote.
  ///
  /// In en, this message translates to:
  /// **'Criticism is the food of haters. Pay no attention to them. They are just total disasters.'**
  String get manuscriptChapter7Quote;

  /// No description provided for @manuscriptChapter8Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter VIII - Counter-Punch'**
  String get manuscriptChapter8Title;

  /// No description provided for @manuscriptChapter8Quote.
  ///
  /// In en, this message translates to:
  /// **'If attacked on social media, use your words—the best, most tremendous words—to counter-punch with overwhelming force at 3 AM.'**
  String get manuscriptChapter8Quote;

  /// No description provided for @manuscriptChapter9Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter IX - Overwhelming Strength'**
  String get manuscriptChapter9Title;

  /// No description provided for @manuscriptChapter9Quote.
  ///
  /// In en, this message translates to:
  /// **'To avoid war, be so strong that nobody would even dream of attacking you. We are talking about overwhelming, unbelievable strength.'**
  String get manuscriptChapter9Quote;

  /// No description provided for @manuscriptChapter10Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter X - Foreign Commanders'**
  String get manuscriptChapter10Title;

  /// No description provided for @manuscriptChapter10Quote.
  ///
  /// In en, this message translates to:
  /// **'Do not trust the foreign commanders, for they are killing us on trade and stealing our jobs. They are not nice people.'**
  String get manuscriptChapter10Quote;

  /// No description provided for @manuscriptChapter11Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XI - Draw a Crowd'**
  String get manuscriptChapter11Title;

  /// No description provided for @manuscriptChapter11Quote.
  ///
  /// In en, this message translates to:
  /// **'A true leader knows how to draw a crowd, and a bigger crowd is always a sign of a better commander, period.'**
  String get manuscriptChapter11Quote;

  /// No description provided for @manuscriptChapter12Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XII - Fake Terrain'**
  String get manuscriptChapter12Title;

  /// No description provided for @manuscriptChapter12Quote.
  ///
  /// In en, this message translates to:
  /// **'If the ground is not to your liking, declare it fake terrain and claim you meant to be somewhere else.'**
  String get manuscriptChapter12Quote;

  /// No description provided for @manuscriptChapter13Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XIII - Greatest Idea'**
  String get manuscriptChapter13Title;

  /// No description provided for @manuscriptChapter13Quote.
  ///
  /// In en, this message translates to:
  /// **'When you have an idea, ensure everyone knows it is your idea, because it is the single greatest idea anyone has ever had.'**
  String get manuscriptChapter13Quote;

  /// No description provided for @manuscriptChapter14Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XIV - Save Strength'**
  String get manuscriptChapter14Title;

  /// No description provided for @manuscriptChapter14Quote.
  ///
  /// In en, this message translates to:
  /// **'Avoid small, unnecessary skirmishes. Save your strength for the big rallies and the huge deals.'**
  String get manuscriptChapter14Quote;

  /// No description provided for @manuscriptChapter15Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XV - Powerful Handshake'**
  String get manuscriptChapter15Title;

  /// No description provided for @manuscriptChapter15Quote.
  ///
  /// In en, this message translates to:
  /// **'When diplomats fail, use a powerful, tremendous handshake to show them who is the strongest, believe me.'**
  String get manuscriptChapter15Quote;

  /// No description provided for @manuscriptChapter16Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XVI - Fine People'**
  String get manuscriptChapter16Title;

  /// No description provided for @manuscriptChapter16Quote.
  ///
  /// In en, this message translates to:
  /// **'In times of conflict, remember that there are very fine people on both sides, as long as one side is not the fake news media.'**
  String get manuscriptChapter16Quote;

  /// No description provided for @manuscriptChapter17Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XVII - Drain the Swamp'**
  String get manuscriptChapter17Title;

  /// No description provided for @manuscriptChapter17Quote.
  ///
  /// In en, this message translates to:
  /// **'When a general is corrupt, you must drain the swamp, because nobody has drained swamps better than me.'**
  String get manuscriptChapter17Quote;

  /// No description provided for @manuscriptChapter18Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XVIII - Ignore Rules'**
  String get manuscriptChapter18Title;

  /// No description provided for @manuscriptChapter18Quote.
  ///
  /// In en, this message translates to:
  /// **'Sometimes, strategy means admitting that the rules are unfair and just ignoring them to win. This is common sense.'**
  String get manuscriptChapter18Quote;

  /// No description provided for @manuscriptChapter19Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XIX - Great Brand'**
  String get manuscriptChapter19Title;

  /// No description provided for @manuscriptChapter19Quote.
  ///
  /// In en, this message translates to:
  /// **'A truly great commander is a brand, a tremendous, very strong, very powerful brand.'**
  String get manuscriptChapter19Quote;

  /// No description provided for @manuscriptChapter20Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XX - Stable Genius'**
  String get manuscriptChapter20Title;

  /// No description provided for @manuscriptChapter20Quote.
  ///
  /// In en, this message translates to:
  /// **'Do not question the wise leader\'s intelligence, because he is a very stable genius.'**
  String get manuscriptChapter20Quote;
}

class _ManuscriptLocalizationsDelegate extends LocalizationsDelegate<ManuscriptLocalizations> {
  const _ManuscriptLocalizationsDelegate();

  @override
  Future<ManuscriptLocalizations> load(Locale locale) {
    return SynchronousFuture<ManuscriptLocalizations>(lookupManuscriptLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['cs', 'de', 'en', 'hu', 'pl', 'sk'].contains(locale.languageCode);

  @override
  bool shouldReload(_ManuscriptLocalizationsDelegate old) => false;
}

ManuscriptLocalizations lookupManuscriptLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs': return ManuscriptLocalizationsCs();
    case 'de': return ManuscriptLocalizationsDe();
    case 'en': return ManuscriptLocalizationsEn();
    case 'hu': return ManuscriptLocalizationsHu();
    case 'pl': return ManuscriptLocalizationsPl();
    case 'sk': return ManuscriptLocalizationsSk();
  }

  throw FlutterError(
    'ManuscriptLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
