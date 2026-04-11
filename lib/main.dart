import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:art_of_deal_war/core/theme/app_theme.dart';
import 'package:art_of_deal_war/core/theme/theme_cubit.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/pages/manuscript_feed_page.dart';
import 'package:art_of_deal_war/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive CE
  await Hive.initFlutter();

  // Setup dependency injection
  di.setupDependencies();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ArtOfDealWarApp());
}

/// Clear all cached data (Hive boxes)
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
          return MaterialApp(
            title: 'The Art of Deal War',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: BlocProvider(
              create: (context) => di.getIt<ManuscriptBloc>(),
              child: const ManuscriptFeedPage(),
            ),
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
