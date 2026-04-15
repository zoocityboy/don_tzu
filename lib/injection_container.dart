import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_local_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_remote_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/data/repositories/manuscript_repository_impl.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';
import 'package:art_of_deal_war/features/manuscript/domain/usecases/get_manuscript_pages_usecase.dart';
import 'package:art_of_deal_war/features/manuscript/domain/usecases/manuscript_usecases.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/intro_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_bloc.dart';
import 'package:art_of_deal_war/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/audio_music_cubit.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/tts_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final settingsBox = await Hive.openBox<dynamic>(SettingsLocalDataSource.boxName);

  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSource(settingsBox),
  );

  getIt.registerLazySingleton<ManuscriptDataSource>(
    () => ManuscriptRemoteDataSourceImpl(),
  );

  getIt.registerFactory<ManuscriptRepository>(
    () => ManuscriptRepositoryImpl(getIt<ManuscriptDataSource>()),
  );

  getIt.registerFactory<GetManuscriptPagesUseCase>(
    () => GetManuscriptPagesUseCase(getIt<ManuscriptRepository>()),
  );
  getIt.registerFactory<ToggleLikeUseCase>(
    () => ToggleLikeUseCase(getIt<ManuscriptRepository>()),
  );

  getIt.registerFactory<IntroBloc>(() => IntroBloc());

  if (kDebugMode) {
    getIt.pushNewScope();
    getIt.registerSingleton<ManuscriptDataSource>(
      ManuscriptLocalDataSourceImpl(),
    );
  }

  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(settingsStorage: getIt<SettingsLocalDataSource>()),
  );

  getIt.registerFactory<ManuscriptBloc>(
    () => ManuscriptBloc(
      getManuscriptPagesUseCase: getIt<GetManuscriptPagesUseCase>(),
      toggleLikeUseCase: getIt<ToggleLikeUseCase>(),
    ),
  );
  getIt.registerFactory<TtsCubit>(
    () => TtsCubit(settingsStorage: getIt<SettingsLocalDataSource>()),
  );
  getIt.registerFactory<AudioMusicCubit>(
    () => AudioMusicCubit(settingsStorage: getIt<SettingsLocalDataSource>()),
  );
}
