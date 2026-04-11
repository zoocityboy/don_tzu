import 'package:art_of_deal_war/core/services/audio_service.dart';
import 'package:art_of_deal_war/core/services/tts_service.dart';
import 'package:art_of_deal_war/core/theme/theme_cubit.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_local_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/data/repositories/manuscript_repository_impl.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerLazySingleton<AudioService>(() => AudioService());
  getIt.registerLazySingleton<TtsService>(() => TtsService());

  // Theme
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  // Data sources
  getIt.registerLazySingleton<ManuscriptLocalDataSource>(
    () => ManuscriptLocalDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<ManuscriptRepository>(
    () => ManuscriptRepositoryImpl(getIt<ManuscriptLocalDataSource>()),
  );

  // BLoCs
  getIt.registerFactory<ManuscriptBloc>(
    () => ManuscriptBloc(getIt<ManuscriptRepository>()),
  );
}
