import 'package:art_of_deal_war/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:art_of_deal_war/features/settings/domain/entities/user_settings.dart';
import 'package:art_of_deal_war/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  @override
  Future<UserSettings> getSettings() async {
    try {
      return await _dataSource.getSettings();
    } on Exception {
      return UserSettings.defaultSettings;
    }
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    await _dataSource.saveSettings(settings);
  }

  @override
  Future<void> clearSettings() async {
    await _dataSource.clearSettings();
  }

  @override
  Future<void> playBackgroundMusic() async {
    await _dataSource.playBackgroundMusic();
  }

  @override
  Future<void> stopBackgroundMusic() async {
    await _dataSource.stopBackgroundMusic();
  }

  @override
  Future<void> setTtsEnabled(bool enabled) async {
    await _dataSource.setTtsEnabled(enabled);
  }

  @override
  Future<bool> checkAndGenerateTts(
    String languageCode,
    List<MapEntry<String, String>> chapters,
  ) async {
    return _dataSource.checkAndGenerateTts(languageCode, chapters);
  }
}
