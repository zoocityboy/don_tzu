import 'package:art_of_deal_war/core/router/app_router.dart';
import 'package:art_of_deal_war/core/services/app_logger.dart';
import 'package:art_of_deal_war/core/services/error_bloc_observer.dart';
import 'package:art_of_deal_war/core/theme/app_theme.dart';
import 'package:art_of_deal_war/features/manuscript/l10n/generated/manuscript_localizations.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_bloc.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:art_of_deal_war/injection_container.dart' as di;
import 'package:art_of_deal_war/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:logging/logging.dart';

void main() async {
  // Initialize logger first
  AppLogger.initialize(defaultLevel: Level.ALL);

  // Set up global error handler for Flutter errors
  FlutterError.presentError = (details) {
    // Log the error
    AppLogger.logException(
      'FlutterError',
      details.exceptionAsString(),
      details.stack,
    );
  };

  // Handle uncaught errors from platform
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    AppLogger.logException('UncaughtError', error, stackTrace);
    return true;
  };

  // Use custom BlocObserver for error handling
  Bloc.observer = AppBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info('Application starting...');

  await Hive.initFlutter();

  await di.setupDependencies();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AppLogger.info('Application initialized successfully');

  runApp(const App());
}

Future<void> clearCache() async {
  try {
    await Hive.deleteFromDisk();
    AppLogger.info('Cache cleared successfully');
  } on Exception catch (e) {
    AppLogger.error('Error clearing cache', e);
  }
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.getIt<ManuscriptBloc>()),
        BlocProvider(create: (_) => di.getIt<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          final themeMode = settings.themeMode;
          final currentLocale = PlatformDispatcher.instance.locale;
          final selectedLocale = Locale(settings.language);
          final locale =
              AppLocalizations.supportedLocales.any(
                (supportedLocale) =>
                    supportedLocale.languageCode == selectedLocale.languageCode,
              )
              ? selectedLocale
              : AppLocalizations.supportedLocales.contains(currentLocale)
              ? currentLocale
              : const Locale('en');

          return MaterialApp.router(
            title: 'The Art of Deal War',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            locale: locale,
            routerConfig: appRouter,
            localizationsDelegates: const [
              ...AppLocalizations.localizationsDelegates,
              ManuscriptLocalizations.delegate,
            ],

            supportedLocales: AppLocalizations.supportedLocales,
            scrollBehavior:
                [
                  TargetPlatform.windows,
                  TargetPlatform.linux,
                  TargetPlatform.macOS,
                ].contains(defaultTargetPlatform)
                ? const MaterialScrollBehavior().copyWith(
                    scrollbars: false,
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                      PointerDeviceKind.stylus,
                      PointerDeviceKind.unknown,
                      PointerDeviceKind.trackpad,
                    },
                  )
                : null,
          );
        },
      ),
    );
  }
}
