import 'package:art_of_deal_war/features/manuscript/l10n/generated/manuscript_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:art_of_deal_war/core/router/app_router.dart';
import 'package:art_of_deal_war/core/theme/app_theme.dart';
import 'package:art_of_deal_war/core/theme/theme_cubit.dart';
import 'package:art_of_deal_war/injection_container.dart' as di;
import 'package:art_of_deal_war/l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  di.setupDependencies();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ArtOfDealWarApp());
}

Future<void> clearCache() async {
  try {
    await Hive.deleteFromDisk();
    debugPrint('Cache cleared successfully');
  } on Exception catch (e) {
    debugPrint('Error clearing cache: $e');
  }
}

class ArtOfDealWarApp extends StatelessWidget {
  const ArtOfDealWarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.getIt<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'The Art of Deal War',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: appRouter,
            localizationsDelegates: [
              AppLocalizations.delegate,
              ManuscriptLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('cs'),
              Locale('de'),
              Locale('hu'),
              Locale('pl'),
              Locale('sk'),
            ],
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
