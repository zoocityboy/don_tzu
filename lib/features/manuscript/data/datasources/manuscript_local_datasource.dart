import 'package:art_of_deal_war/features/manuscript/data/models/manuscript_page_model.dart';
import 'package:art_of_deal_war/features/manuscript/l10n/generated/manuscript_localizations.dart';

abstract class ManuscriptLocalDataSource {
  Future<Set<String>> getLikedPageIds();
  Future<List<ManuscriptPageModel>> getManuscriptPages(
    ManuscriptLocalizations l10n,
  );
  List<MapEntry<String, String>> getChaptersForTts(
    ManuscriptLocalizations l10n,
  );
  Future<void> saveLikedPageIds(Set<String> ids);
}

class ManuscriptLocalDataSourceImpl implements ManuscriptLocalDataSource {
  @override
  Future<Set<String>> getLikedPageIds() async {
    return {};
  }

  @override
  Future<List<ManuscriptPageModel>> getManuscriptPages(
    ManuscriptLocalizations l10n,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return [
      ManuscriptPageModel(
        id: '1',
        title: l10n.manuscriptChapter1Title,
        quote: l10n.manuscriptChapter1Quote,
        imageAsset: 'assets/images/1.webp',
      ),
      ManuscriptPageModel(
        id: '2',
        title: l10n.manuscriptChapter2Title,
        quote: l10n.manuscriptChapter2Quote,
        imageAsset: 'assets/images/2.webp',
      ),
      ManuscriptPageModel(
        id: '3',
        title: l10n.manuscriptChapter3Title,
        quote: l10n.manuscriptChapter3Quote,
        imageAsset: 'assets/images/3.webp',
      ),
      ManuscriptPageModel(
        id: '4',
        title: l10n.manuscriptChapter4Title,
        quote: l10n.manuscriptChapter4Quote,
        imageAsset: 'assets/images/4.webp',
      ),
      ManuscriptPageModel(
        id: '5',
        title: l10n.manuscriptChapter5Title,
        quote: l10n.manuscriptChapter5Quote,
        imageAsset: 'assets/images/5.webp',
      ),
      ManuscriptPageModel(
        id: '6',
        title: l10n.manuscriptChapter6Title,
        quote: l10n.manuscriptChapter6Quote,
        imageAsset: 'assets/images/6.webp',
      ),
      ManuscriptPageModel(
        id: '7',
        title: l10n.manuscriptChapter7Title,
        quote: l10n.manuscriptChapter7Quote,
        imageAsset: 'assets/images/7.webp',
      ),
      ManuscriptPageModel(
        id: '8',
        title: l10n.manuscriptChapter8Title,
        quote: l10n.manuscriptChapter8Quote,
        imageAsset: 'assets/images/8.webp',
      ),
      ManuscriptPageModel(
        id: '9',
        title: l10n.manuscriptChapter9Title,
        quote: l10n.manuscriptChapter9Quote,
        imageAsset: 'assets/images/9.webp',
      ),
      ManuscriptPageModel(
        id: '10',
        title: l10n.manuscriptChapter10Title,
        quote: l10n.manuscriptChapter10Quote,
        imageAsset: 'assets/images/10.webp',
      ),
      ManuscriptPageModel(
        id: '11',
        title: l10n.manuscriptChapter11Title,
        quote: l10n.manuscriptChapter11Quote,
        imageAsset: 'assets/images/11.webp',
      ),
      ManuscriptPageModel(
        id: '12',
        title: l10n.manuscriptChapter12Title,
        quote: l10n.manuscriptChapter12Quote,
        imageAsset: 'assets/images/12.webp',
      ),
      ManuscriptPageModel(
        id: '13',
        title: l10n.manuscriptChapter13Title,
        quote: l10n.manuscriptChapter13Quote,
        imageAsset: 'assets/images/13.webp',
      ),
      ManuscriptPageModel(
        id: '14',
        title: l10n.manuscriptChapter14Title,
        quote: l10n.manuscriptChapter14Quote,
        imageAsset: 'assets/images/14.webp',
      ),
      ManuscriptPageModel(
        id: '15',
        title: l10n.manuscriptChapter15Title,
        quote: l10n.manuscriptChapter15Quote,
        imageAsset: 'assets/images/15.webp',
      ),
      ManuscriptPageModel(
        id: '16',
        title: l10n.manuscriptChapter16Title,
        quote: l10n.manuscriptChapter16Quote,
        imageAsset: 'assets/images/16.webp',
      ),
      ManuscriptPageModel(
        id: '17',
        title: l10n.manuscriptChapter17Title,
        quote: l10n.manuscriptChapter17Quote,
        imageAsset: 'assets/images/17.webp',
      ),
      ManuscriptPageModel(
        id: '18',
        title: l10n.manuscriptChapter18Title,
        quote: l10n.manuscriptChapter18Quote,
        imageAsset: 'assets/images/18.webp',
      ),
      ManuscriptPageModel(
        id: '19',
        title: l10n.manuscriptChapter19Title,
        quote: l10n.manuscriptChapter19Quote,
        imageAsset: 'assets/images/19.webp',
      ),
      ManuscriptPageModel(
        id: '20',
        title: l10n.manuscriptChapter20Title,
        quote: l10n.manuscriptChapter20Quote,
        imageAsset: 'assets/images/20.webp',
      ),
    ];
  }

  @override
  Future<void> saveLikedPageIds(Set<String> ids) async {}

  @override
  List<MapEntry<String, String>> getChaptersForTts(
    ManuscriptLocalizations l10n,
  ) {
    return [
      MapEntry(
        '1',
        l10n.manuscriptChapter1Quote,
      ),
      MapEntry(
        '2',
        l10n.manuscriptChapter2Quote,
      ),
      MapEntry(
        '3',
        l10n.manuscriptChapter3Quote,
      ),
      MapEntry(
        '4',
        l10n.manuscriptChapter4Quote,
      ),
      MapEntry(
        '5',
        l10n.manuscriptChapter5Quote,
      ),
      MapEntry(
        '6',
        l10n.manuscriptChapter6Quote,
      ),
      MapEntry(
        '7',
        l10n.manuscriptChapter7Quote,
      ),
      MapEntry(
        '8',
        l10n.manuscriptChapter8Quote,
      ),
      MapEntry(
        '9',
        l10n.manuscriptChapter9Quote,
      ),
      MapEntry(
        '10',
        l10n.manuscriptChapter10Quote,
      ),
      MapEntry(
        '11',
        l10n.manuscriptChapter11Quote,
      ),
      MapEntry(
        '12',
        l10n.manuscriptChapter12Quote,
      ),
      MapEntry(
        '13',
        l10n.manuscriptChapter13Quote,
      ),
      MapEntry(
        '14',
        l10n.manuscriptChapter14Quote,
      ),
      MapEntry(
        '15',
        l10n.manuscriptChapter15Quote,
      ),
      MapEntry(
        '16',
        l10n.manuscriptChapter16Quote,
      ),
      MapEntry(
        '17',
        l10n.manuscriptChapter17Quote,
      ),
      MapEntry(
        '18',
        l10n.manuscriptChapter18Quote,
      ),
      MapEntry(
        '19',
        l10n.manuscriptChapter19Quote,
      ),
      MapEntry(
        '20',
        l10n.manuscriptChapter20Quote,
      ),
    ];
  }
}
