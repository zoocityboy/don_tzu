import 'package:art_of_deal_war/features/settings/domain/entities/user_settings.dart';

abstract class SettingsRepository {
  Future<UserSettings> getSettings();
  Future<void> saveSettings(UserSettings settings);
  Future<void> clearSettings();
  Future<void> playBackgroundMusic();
  Future<void> stopBackgroundMusic();
  Future<void> setTtsEnabled(bool enabled);
  Future<bool> checkAndGenerateTts(
    String languageCode,
    List<MapEntry<String, String>> chapters,
  );
}
