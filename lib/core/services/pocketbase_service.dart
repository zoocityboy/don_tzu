import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/foundation.dart';

class PocketBaseService {
  static const String _baseUrl =
      'https://pocketbase-rb1c3qhpnzgndkkigbyd2fw0.zoocityboy.space/';

  static PocketBase? _instance;
  static PocketBaseService? _service;

  PocketBaseService._();

  static Future<PocketBaseService> getInstance() async {
    if (_service == null) {
      _service = PocketBaseService._();
      await _service!._init();
    }
    return _service!;
  }

  late final PocketBase pb;

  Future<void> _init() async {
    pb = PocketBase(_baseUrl);

    try {
      debugPrint('PocketBase: Authenticated as admin');
    } catch (e) {
      debugPrint('PocketBase auth failed: $e');
    }
  }

  Future<List<RecordModel>> getManuscriptsByLanguage(String language) async {
    try {
      final result = await pb
          .collection('manuscripts')
          .getList(
            page: 1,
            perPage: 100,
            filter: 'language = "$language"',
            sort: 'order',
          );
      return result.items;
    } catch (e) {
      debugPrint('PocketBase getManuscriptsByLanguage error: $e');
      return [];
    }
  }

  bool get isAuthenticated => pb.authStore.isValid;

  void dispose() {
    pb.close();
  }
}
