import 'package:art_of_deal_war/features/manuscript/l10n/generated/manuscript_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:art_of_deal_war/core/services/tts_service.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_local_datasource.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/intro_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/intro_event.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_event.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/pages/intro_cover_page.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/pages/manuscript_feed_page.dart';
import 'package:art_of_deal_war/injection_container.dart' as di;

const String _intro = '/intro';
const String _home = '/';

final GoRouter appRouter = GoRouter(
  initialLocation: _intro,
  routes: [
    GoRoute(
      path: _intro,
      pageBuilder: (context, state) {
        final l10n = ManuscriptLocalizations.of(context)!;
        final locale = Localizations.localeOf(context);
        final language = '${locale.languageCode}-${locale.countryCode ?? ''}';
        return MaterialPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => IntroBloc(
              di.getIt<TtsService>(),
              di.getIt<ManuscriptLocalDataSource>(),
            )..add(InitializeIntro(language: language)),
            child: IntroCoverPage(
              onEnter: () => context.go(_home),
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: _home,
      pageBuilder: (context, state) {
        final l10n = ManuscriptLocalizations.of(context)!;
        final locale = Localizations.localeOf(context);
        final language = '${locale.languageCode}-${locale.countryCode ?? ''}';
        return MaterialPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (context) => ManuscriptBloc(
              di.getIt<ManuscriptRepository>(),
              di.getIt<TtsService>(),
              di.getIt<ManuscriptLocalDataSource>(),
            )..add(LoadManuscriptPages(language: language)),
            child: const ManuscriptFeedPage(),
          ),
        );
      },
    ),
  ],
);
