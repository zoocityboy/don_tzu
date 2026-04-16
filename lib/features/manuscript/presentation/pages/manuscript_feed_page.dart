import 'package:art_of_deal_war/core/theme/app_theme.dart';
import 'package:art_of_deal_war/features/manuscript/domain/entities/manuscript_page.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_event.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_state.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/widgets/manuscript_page_card.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/widgets/settings_bottom_sheet.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/tts_cubit.dart';
import 'package:art_of_deal_war/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class ActionBarWidget extends StatelessWidget {
  final ManuscriptPage page;
  final VoidCallback onLike;
  final VoidCallback onShare;

  const ActionBarWidget({
    super.key,
    required this.page,
    required this.onLike,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkInkLight : AppColors.inkLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _VerticalActionButton(
          icon: page.isLiked ? Icons.favorite : Icons.favorite_border,
          label: page.isLiked ? 'Liked' : 'Like',
          color: page.isLiked ? AppColors.vermillion : textColor,
          onTap: onLike,
        ),
        const SizedBox(height: 16),
        _VerticalActionButton(
          icon: Icons.share_outlined,
          label: 'Share',
          color: textColor,
          onTap: onShare,
        ),
        const SizedBox(height: 16),
        const _SealStampButton(),
      ],
    );
  }
}

class _VerticalActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _VerticalActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.notoSansJp(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  blurRadius: 2,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SealStampButton extends StatelessWidget {
  const _SealStampButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        SettingsBottomSheet.show(context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.vermillion, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '戰',
          style: GoogleFonts.notoSerifJp(
            fontSize: 24,
            color: AppColors.vermillion,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class CenteredLayout extends StatelessWidget {
  final List<ManuscriptPage> pages;
  final int currentPage;
  final PageController pageController;
  final void Function(int) onPageChanged;
  final void Function(String) onLike;
  final void Function(ManuscriptPage) onShare;
  final TtsCubit ttsCubit;

  const CenteredLayout({
    super.key,
    required this.pages,
    required this.currentPage,
    required this.pageController,
    required this.onPageChanged,
    required this.onLike,
    required this.onShare,
    required this.ttsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: pageController,
              scrollDirection: Axis.vertical,
              physics: const PageScrollPhysics(),
              itemCount: pages.length,
              onPageChanged: onPageChanged,
              itemBuilder: (context, index) {
                final page = pages[index];
                return PageContentWidget(
                  page: page,
                  onLike: () => onLike(page.id),
                  onShare: () => onShare(page),
                );
              },
            ),
            // Right-side action buttons (TikTok style)
            Positioned(
              right: 16,
              bottom: 32,
              child: SafeArea(
                child: ActionBarWidget(
                  page: pages[currentPage],
                  onLike: () => onLike(pages[currentPage].id),
                  onShare: () => onShare(pages[currentPage]),
                ),
              ),
            ),
            // Page indicator at bottom of screen
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: PageIndicatorWidget(
                  totalPages: pages.length,
                  currentPage: currentPage,
                ),
              ),
            ),
            // Top-right controls
            Positioned(
              top: 0,
              right: 16,
              child: SafeArea(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 8,
                  children: [
                    TtsMuteButton(ttsCubit: ttsCubit),
                    const SettingsToggleButton(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.vermillion),
    );
  }
}

class ManuscriptErrorWidget extends StatelessWidget {
  final String message;

  const ManuscriptErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.vermillion,
          ),
          const SizedBox(height: 16),
          Text(message, style: GoogleFonts.notoSerif(color: AppColors.inkGray)),
        ],
      ),
    );
  }
}

class PageContentWidget extends StatefulWidget {
  final ManuscriptPage page;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final bool shouldAnimate;

  const PageContentWidget({
    super.key,
    required this.page,
    required this.onLike,
    required this.onShare,
    this.shouldAnimate = false,
  });

  @override
  State<PageContentWidget> createState() => _PageContentWidgetState();
}

class _PageContentWidgetState extends State<PageContentWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paperBase = isDark ? AppColors.darkPaperBase : AppColors.paperBase;
    final inkBlack = isDark ? AppColors.darkInkLight : AppColors.inkBlack;
    final inkGray = isDark ? AppColors.darkInkGray : AppColors.inkGray;

    return GestureDetector(
      onDoubleTap: () {
        HapticFeedback.mediumImpact();
        widget.onLike();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: paperBase,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PaperTextureWidget(isDark: isDark),
            AgedEdgesWidget(isDark: isDark),
            AnimatedCharacterImageWidget(page: widget.page, isDark: isDark),
            SafeArea(
              child: AnimatedTextContentWidget(
                title: widget.page.title,
                quote: widget.page.quote,
                inkBlack: inkBlack,
                inkGray: inkGray,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageIndicatorWidget extends StatelessWidget {
  final int totalPages;
  final int currentPage;

  const PageIndicatorWidget({
    super.key,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final displayPages = totalPages > 10 ? 10 : totalPages;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkInkLight : AppColors.inkLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${currentPage + 1} / $totalPages',
          style: GoogleFonts.notoSansJp(
            fontSize: 12,
            color: textColor.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(displayPages, (index) {
            final isCurrentInRange = currentPage < 10
                ? index == currentPage
                : index == 9;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isCurrentInRange ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isCurrentInRange
                    ? AppColors.vermillion
                    : textColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class SettingsToggleButton extends StatelessWidget {
  const SettingsToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        SettingsBottomSheet.show(context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.darkPaperAged : AppColors.paperAged)
              .withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.inkLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.settings_outlined,
          color: isDark ? AppColors.darkInkLight : AppColors.inkLight,
          size: 20,
        ),
      ),
    );
  }
}

class TtsMuteButton extends StatelessWidget {
  final TtsCubit ttsCubit;

  const TtsMuteButton({super.key, required this.ttsCubit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<TtsCubit, TtsState>(
      bloc: ttsCubit,
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            HapticFeedback.lightImpact();
            await ttsCubit.toggleMute();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkPaperAged : AppColors.paperAged)
                  .withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.inkLight.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return Icon(
                  state.ttsReaderEnabled ? Icons.volume_up : Icons.volume_off,
                  color: isDark ? AppColors.darkInkLight : AppColors.inkLight,
                  size: 20,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class ManuscriptFeedPage extends StatefulWidget {
  const ManuscriptFeedPage({super.key});

  @override
  State<ManuscriptFeedPage> createState() => _ManuscriptFeedPageState();
}

class _ManuscriptFeedPageState extends State<ManuscriptFeedPage> {
  final PageController _pageController = PageController();
  late final TtsCubit _ttsCubit;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _ttsCubit = di.getIt<TtsCubit>();
    context.read<ManuscriptBloc>().add(const LoadManuscriptPages());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkPaperBase : AppColors.paperBase,
      body: BlocListener<SettingsCubit, SettingsState>(
        listenWhen: (prev, curr) => prev.language != curr.language,
        listener: (context, state) {
          _ttsCubit.stop();
          _currentPage = 0;
          _pageController.jumpToPage(0);
          context.read<ManuscriptBloc>().add(
            LoadManuscriptPages(language: state.language),
          );
        },
        child: BlocBuilder<ManuscriptBloc, ManuscriptState>(
          builder: (context, state) => _buildBody(state),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ttsCubit.stop();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildBody(ManuscriptState state) {
    return switch (state) {
      ManuscriptLoading() => const LoadingWidget(),
      ManuscriptError(message: final msg) => ManuscriptErrorWidget(
        message: msg,
      ),
      ManuscriptLoaded(pages: final pages) => CenteredLayout(
        pages: pages,
        currentPage: _currentPage,
        pageController: _pageController,
        onPageChanged: _onPageChanged,
        onLike: _onLike,
        onShare: _sharePage,
        ttsCubit: _ttsCubit,
      ),
      _ => const LoadingWidget(),
    };
  }

  void _onLike(String pageId) {
    HapticFeedback.lightImpact();
    context.read<ManuscriptBloc>().add(ToggleLike(pageId));
  }

  void _onPageChanged(int index) {
    if (index != _currentPage) {
      _ttsCubit.stop();
    }
    setState(() => _currentPage = index);
    final state = context.read<ManuscriptBloc>().state;
    if (state is ManuscriptLoaded && index < state.pages.length) {
      final page = state.pages[index];
      final settingsState = context.read<SettingsCubit>().state;
      if (settingsState.ttsReaderEnabled) {
        _ttsCubit.play(page.audioAsset);
      }
    }
  }

  Future<void> _sharePage(ManuscriptPage page) async {
    final text =
        '''${page.title}

"${page.quote}"

— The Art of Deal War

Shared from The Art of Deal War app''';
    await Share.share(text);
  }
}
