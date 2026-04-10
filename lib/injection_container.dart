import 'package:get_it/get_it.dart';
import 'features/manuscript/data/datasources/manuscript_local_datasource.dart';
import 'features/manuscript/data/repositories/manuscript_repository_impl.dart';
import 'features/manuscript/domain/repositories/manuscript_repository.dart';
import 'features/manuscript/presentation/bloc/manuscript_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
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
