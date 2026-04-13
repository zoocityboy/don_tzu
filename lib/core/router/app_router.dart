import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:art_of_deal_war/core/theme/settings_cubit.dart';
import 'package:art_of_deal_war/features/manuscript/domain/repositories/manuscript_repository.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/intro_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/intro_event.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/pages/intro_cover_page.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/pages/manuscript_feed_page.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/widgets/settings_bottom_sheet.dart';
import 'package:art_of_deal_war/injection_container.dart' as di;

const String _intro = '/intro';
const String _home = '/';
const String _settings = '/settings';

final GoRouter appRouter = GoRouter(
  initialLocation: _intro,
  routes: [
    GoRoute(
      path: _intro,
      builder: (context, state) {
        final locale = Localizations.localeOf(context);
        final language = '${locale.languageCode}-${locale.countryCode ?? ''}';
        return BlocProvider(
          create: (context) => IntroBloc(
            repository: di.getIt<ManuscriptRepository>(),
          )..add(InitializeIntro(language: language)),
          child: IntroCoverPage(
            onEnter: () => context.go(_home),
          ),
        );
      },
    ),
    GoRoute(
      path: _home,
      builder: (context, state) {
        return const ManuscriptFeedPage();
      },
    ),
    GoRoute(
      path: _settings,
      pageBuilder: (context, state) {
        return BottomSheetPage(
          key: state.pageKey,
          child: const _SettingsSheetWrapper(),
        );
      },
    ),
  ],
);

class _SettingsSheetWrapper extends StatelessWidget {
  const _SettingsSheetWrapper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SettingsBottomSheet(
        showCloseButton: true,
        onClose: () => context.pop(),
      ),
    );
  }
}

class BottomSheetPage<T> extends Page<T> {
  final Widget child;
  final bool showDragHandle;
  final bool useSafeArea;

  const BottomSheetPage({
    required this.child,
    this.showDragHandle = false,
    this.useSafeArea = true,
    super.key,
  });

  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
    settings: this,
    isScrollControlled: true,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: BlocProvider.of<SettingsCubit>(context),
      child: child,
    ),
  );
}
