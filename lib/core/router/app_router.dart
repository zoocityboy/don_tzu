import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_bloc.dart';
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
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: IntroCoverPage(
          onEnter: () => context.go(_home),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: _home,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: BlocProvider(
          create: (context) => di.getIt<ManuscriptBloc>(),
          child: const ManuscriptFeedPage(),
        ),
      ),
    ),
  ],
);
