import 'package:art_of_deal_war/core/services/tts_service.dart';
import 'package:art_of_deal_war/core/services/background_music_player.dart';
import 'package:art_of_deal_war/core/services/tts_audio_player.dart';
import 'package:art_of_deal_war/core/services/pocketbase_service.dart';
import 'package:art_of_deal_war/core/theme/settings_cubit.dart';
import 'package:art_of_deal_war/core/theme/theme_cubit.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_remote_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/data/repositories/manuscript_repository_impl.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/intro_bloc.dart';
import 'package:art_of_deal_war/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:art_of_deal_war/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:art_of_deal_war/features/settings/domain/repositories/settings_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Services
  getIt.registerLazySingleton<BackgroundMusicPlayer>(
    () => BackgroundMusicPlayer(),
  );
  getIt.registerLazySingleton<TtsAudioPlayer>(() => TtsAudioPlayer());
  getIt.registerLazySingleton<TtsService>(() => TtsService());

  // PocketBase
  final pbService = await PocketBaseService.getInstance();
  getIt.registerLazySingleton<PocketBaseService>(() => pbService);

  getIt.registerFactory<ThemeCubit>(() => ThemeCubit());

  // Settings
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(
      audioPlayerService: getIt<BackgroundMusicPlayer>(),
      ttsService: getIt<TtsService>(),
      ttsAudioPlayer: getIt<TtsAudioPlayer>(),
    ),
  );
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt<SettingsLocalDataSource>()),
  );
  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(
      repository: getIt<SettingsRepository>(),
    ),
  );

  // Manuscripts - Remote data source with PocketBase + fallback to local JSON
  getIt.registerLazySingleton<ManuscriptLocalDataSource>(
    () => ManuscriptRemoteDataSource(
      pocketBaseService: pbService,
      ttsService: getIt<TtsService>(),
      ttsAudioPlayer: getIt<TtsAudioPlayer>(),
    ),
  );

  getIt.registerLazySingleton<ManuscriptRepository>(
    () => ManuscriptRepositoryImpl(getIt<ManuscriptLocalDataSource>()),
  );

  // BLoCs
  getIt.registerFactory<ManuscriptBloc>(
    () => ManuscriptBloc(
      repository: getIt<ManuscriptRepository>(),
    ),
  );

  getIt.registerFactory<IntroBloc>(
    () => IntroBloc(
      repository: getIt<ManuscriptRepository>(),
    ),
  );
}
