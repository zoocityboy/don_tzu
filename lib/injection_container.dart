import 'package:art_of_deal_war/core/services/pocketbase_service.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_remote_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/data/repositories/manuscript_repository_impl.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';
import 'package:art_of_deal_war/features/manuscript/domain/usecases/get_manuscript_pages_usecase.dart';
import 'package:art_of_deal_war/features/manuscript/domain/usecases/manuscript_usecases.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/intro_bloc.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/tts_cubit.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/audio_music_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final pbService = await PocketBaseService.getInstance();
  getIt.registerLazySingleton<PocketBaseService>(() => pbService);

  getIt.registerFactory<TtsCubit>(() => TtsCubit());
  getIt.registerLazySingleton<AudioMusicCubit>(() => AudioMusicCubit());

  getIt.registerLazySingleton<ManuscriptLocalDataSource>(
    () => ManuscriptRemoteDataSource(
      pocketBaseService: pbService,
      ttsCubit: getIt<TtsCubit>(),
    ),
  );

  getIt.registerLazySingleton<ManuscriptRepository>(
    () => ManuscriptRepositoryImpl(getIt<ManuscriptLocalDataSource>()),
  );

  getIt.registerFactory<GetManuscriptPagesUseCase>(
    () => GetManuscriptPagesUseCase(getIt<ManuscriptRepository>()),
  );
  getIt.registerFactory<ToggleLikeUseCase>(
    () => ToggleLikeUseCase(getIt<ManuscriptRepository>()),
  );

  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(
      audioMusicCubit: getIt<AudioMusicCubit>(),
      ttsCubit: getIt<TtsCubit>(),
    ),
  );

  getIt.registerFactory<ManuscriptBloc>(
    () => ManuscriptBloc(
      getManuscriptPagesUseCase: getIt<GetManuscriptPagesUseCase>(),
      toggleLikeUseCase: getIt<ToggleLikeUseCase>(),
      ttsCubit: getIt<TtsCubit>(),
    ),
  );

  getIt.registerFactory<IntroBloc>(
    () => IntroBloc(
      ttsCubit: getIt<TtsCubit>(),
    ),
  );
}
