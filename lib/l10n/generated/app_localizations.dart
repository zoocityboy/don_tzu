import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_sk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
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
    Locale('sk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'The Art of Deal War'**
  String get appTitle;

  /// No description provided for @introSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A 2500 Year Old Discovery'**
  String get introSubtitle;

  /// No description provided for @openTheScroll.
  ///
  /// In en, this message translates to:
  /// **'OPEN THE SCROLL'**
  String get openTheScroll;

  /// No description provided for @storyParagraph1.
  ///
  /// In en, this message translates to:
  /// **'In 2024, archeologists uncovered a sealed vault in the Arizona desert containing ancient military scrolls from 250 BC.'**
  String get storyParagraph1;

  /// No description provided for @storyParagraph2.
  ///
  /// In en, this message translates to:
  /// **'Among them was \"The Art of Deal War\" - a strategic military treatise written by Commander-in-Chief Don Tzu.'**
  String get storyParagraph2;

  /// No description provided for @storyParagraph3.
  ///
  /// In en, this message translates to:
  /// **'Until now, these pages remained hidden from the public...'**
  String get storyParagraph3;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @liked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get liked;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'{title}\n\n\"{quote}\"\n\n— The Art of Deal War\n\nShared from The Art of Deal War app'**
  String shareText(Object quote, Object title);

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared!'**
  String get cacheCleared;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Failed to load content'**
  String get errorLoading;

  /// No description provided for @chapter1Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter I - Total Victory'**
  String get chapter1Title;

  /// No description provided for @chapter1Quote.
  ///
  /// In en, this message translates to:
  /// **'The goal is total victory, and we are going to win so much you will get tired of winning. Many people are saying it.'**
  String get chapter1Quote;

  /// No description provided for @chapter2Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter II - Know Your Enemy'**
  String get chapter2Title;

  /// No description provided for @chapter2Quote.
  ///
  /// In en, this message translates to:
  /// **'Always know your enemy, especially the fake news media, for they are unfair to a tremendous degree.'**
  String get chapter2Quote;

  /// No description provided for @chapter3Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter III - Strong Commander'**
  String get chapter3Title;

  /// No description provided for @chapter3Quote.
  ///
  /// In en, this message translates to:
  /// **'A wise commander keeps his troops strong with the best equipment and the highest pay, maybe ever.'**
  String get chapter3Quote;

  /// No description provided for @chapter4Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter IV - The Wall'**
  String get chapter4Title;

  /// No description provided for @chapter4Quote.
  ///
  /// In en, this message translates to:
  /// **'Build a wall. A tremendously hugest wall. It keeps the bad hombres out and makes the neighbor pay for it.'**
  String get chapter4Quote;

  /// No description provided for @chapter5Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter V - Stable General'**
  String get chapter5Title;

  /// No description provided for @chapter5Quote.
  ///
  /// In en, this message translates to:
  /// **'The stable general has a very good brain, maybe the best brain in the entire army, believe me.'**
  String get chapter5Quote;

  /// No description provided for @chapter6Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter VI - Greatest Deal'**
  String get chapter6Title;

  /// No description provided for @chapter6Quote.
  ///
  /// In en, this message translates to:
  /// **'When you make a deal, make the greatest deal in history. Otherwise, you are a loser, and no one likes a loser.'**
  String get chapter6Quote;

  /// No description provided for @chapter7Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter VII - Ignore Haters'**
  String get chapter7Title;

  /// No description provided for @chapter7Quote.
  ///
  /// In en, this message translates to:
  /// **'Criticism is the food of haters. Pay no attention to them. They are just total disasters.'**
  String get chapter7Quote;

  /// No description provided for @chapter8Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter VIII - Counter-Punch'**
  String get chapter8Title;

  /// No description provided for @chapter8Quote.
  ///
  /// In en, this message translates to:
  /// **'If attacked on social media, use your words—the best, most tremendous words—to counter-punch with overwhelming force at 3 AM.'**
  String get chapter8Quote;

  /// No description provided for @chapter9Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter IX - Overwhelming Strength'**
  String get chapter9Title;

  /// No description provided for @chapter9Quote.
  ///
  /// In en, this message translates to:
  /// **'To avoid war, be so strong that nobody would even dream of attacking you. We are talking about overwhelming, unbelievable strength.'**
  String get chapter9Quote;

  /// No description provided for @chapter10Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter X - Foreign Commanders'**
  String get chapter10Title;

  /// No description provided for @chapter10Quote.
  ///
  /// In en, this message translates to:
  /// **'Do not trust the foreign commanders, for they are killing us on trade and stealing our jobs. They are not nice people.'**
  String get chapter10Quote;

  /// No description provided for @chapter11Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XI - Draw a Crowd'**
  String get chapter11Title;

  /// No description provided for @chapter11Quote.
  ///
  /// In en, this message translates to:
  /// **'A true leader knows how to draw a crowd, and a bigger crowd is always a sign of a better commander, period.'**
  String get chapter11Quote;

  /// No description provided for @chapter12Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XII - Fake Terrain'**
  String get chapter12Title;

  /// No description provided for @chapter12Quote.
  ///
  /// In en, this message translates to:
  /// **'If the ground is not to your liking, declare it fake terrain and claim you meant to be somewhere else.'**
  String get chapter12Quote;

  /// No description provided for @chapter13Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XIII - Greatest Idea'**
  String get chapter13Title;

  /// No description provided for @chapter13Quote.
  ///
  /// In en, this message translates to:
  /// **'When you have an idea, ensure everyone knows it is your idea, because it is the single greatest idea anyone has ever had.'**
  String get chapter13Quote;

  /// No description provided for @chapter14Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XIV - Save Strength'**
  String get chapter14Title;

  /// No description provided for @chapter14Quote.
  ///
  /// In en, this message translates to:
  /// **'Avoid small, unnecessary skirmishes. Save your strength for the big rallies and the huge deals.'**
  String get chapter14Quote;

  /// No description provided for @chapter15Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XV - Powerful Handshake'**
  String get chapter15Title;

  /// No description provided for @chapter15Quote.
  ///
  /// In en, this message translates to:
  /// **'When diplomats fail, use a powerful, tremendous handshake to show them who is the strongest, believe me.'**
  String get chapter15Quote;

  /// No description provided for @chapter16Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XVI - Fine People'**
  String get chapter16Title;

  /// No description provided for @chapter16Quote.
  ///
  /// In en, this message translates to:
  /// **'In times of conflict, remember that there are very fine people on both sides, as long as one side is not the fake news media.'**
  String get chapter16Quote;

  /// No description provided for @chapter17Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XVII - Drain the Swamp'**
  String get chapter17Title;

  /// No description provided for @chapter17Quote.
  ///
  /// In en, this message translates to:
  /// **'When a general is corrupt, you must drain the swamp, because nobody has drained swamps better than me.'**
  String get chapter17Quote;

  /// No description provided for @chapter18Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XVIII - Ignore Rules'**
  String get chapter18Title;

  /// No description provided for @chapter18Quote.
  ///
  /// In en, this message translates to:
  /// **'Sometimes, strategy means admitting that the rules are unfair and just ignoring them to win. This is common sense.'**
  String get chapter18Quote;

  /// No description provided for @chapter19Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XIX - Great Brand'**
  String get chapter19Title;

  /// No description provided for @chapter19Quote.
  ///
  /// In en, this message translates to:
  /// **'A truly great commander is a brand, a tremendous, very strong, very powerful brand.'**
  String get chapter19Quote;

  /// No description provided for @chapter20Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter XX - Stable Genius'**
  String get chapter20Title;

  /// No description provided for @chapter20Quote.
  ///
  /// In en, this message translates to:
  /// **'Do not question the wise leader\'s intelligence, because he is a very stable genius.'**
  String get chapter20Quote;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'de',
    'en',
    'hu',
    'pl',
    'sk',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'hu':
      return AppLocalizationsHu();
    case 'pl':
      return AppLocalizationsPl();
    case 'sk':
      return AppLocalizationsSk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
