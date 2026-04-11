import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import 'package:art_of_deal_war/core/services/tts_service.dart';
import 'package:art_of_deal_war/core/theme/app_theme.dart';
import 'package:art_of_deal_war/core/theme/theme_cubit.dart';
import 'package:art_of_deal_war/features/manuscript/domain/entities/manuscript_page.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_event.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_state.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/widgets/manuscript_page_card.dart';
import 'package:art_of_deal_war/main.dart' show clearCache;
import 'package:art_of_deal_war/injection_container.dart' as di;

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
    final surfaceColor = isDark ? AppColors.darkPaperAged : AppColors.paperAged;
    final textColor = isDark ? AppColors.darkInkLight : AppColors.inkLight;

    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.agedBrown.withValues(alpha: 0.9),
          width: 1,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ActionButtonWidget(
              icon: page.isLiked ? Icons.favorite : Icons.favorite_border,
              label: page.isLiked ? 'Liked' : 'Like',
              color: page.isLiked ? AppColors.vermillion : textColor,
              onTap: onLike,
            ),
            Container(
              height: 30,
              width: 1,
              color: AppColors.inkLight.withValues(alpha: 0.1),
            ),
            ActionButtonWidget(
              icon: Icons.share_outlined,
              label: 'Share',
              color: textColor,
              onTap: onShare,
            ),
            Container(
              height: 30,
              width: 1,
              color: AppColors.inkLight.withValues(alpha: 0.1),
            ),
            const SealStampWidget(),
          ],
        ),
      ),
    );
  }
}

class ActionButtonWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ActionButtonWidget({
    super.key,
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.notoSansJp(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
  final TtsService ttsService;

  const CenteredLayout({
    super.key,
    required this.pages,
    required this.currentPage,
    required this.pageController,
    required this.onPageChanged,
    required this.onLike,
    required this.onShare,
    required this.ttsService,
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
            Positioned(
              bottom: 140,
              left: 0,
              right: 0,
              child: SafeArea(
                child: PageIndicatorWidget(
                  totalPages: pages.length,
                  currentPage: currentPage,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 16,
              child: SafeArea(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TtsMuteButton(ttsService: ttsService),
                    const SizedBox(width: 8),
                    const ThemeToggleButton(),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: constraints.maxHeight * 0.04,
              child: SafeArea(
                child: ActionBarWidget(
                  page: pages[currentPage],
                  onLike: () => onLike(pages[currentPage].id),
                  onShare: () => onShare(pages[currentPage]),
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

class ManuscriptFeedPage extends StatefulWidget {
  const ManuscriptFeedPage({super.key});

  @override
  State<ManuscriptFeedPage> createState() => _ManuscriptFeedPageState();
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
            AnimatedCharacterImageWidget(
              page: widget.page,
              isDark: isDark,
            ),
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

class SealStampWidget extends StatelessWidget {
  const SealStampWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        HapticFeedback.heavyImpact();
        final cacheCleared = clearCache();
        await cacheCleared;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cache cleared!', style: GoogleFonts.notoSansJp()),
              backgroundColor: AppColors.vermillion,
            ),
          );
        }
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
            fontSize: 20,
            color: AppColors.vermillion,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.read<ThemeCubit>().toggleTheme();
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
          isDark ? Icons.light_mode : Icons.dark_mode,
          color: isDark ? AppColors.darkInkLight : AppColors.inkLight,
          size: 20,
        ),
      ),
    );
  }
}

class TtsMuteButton extends StatelessWidget {
  final TtsService ttsService;

  const TtsMuteButton({super.key, required this.ttsService});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            ttsService.toggleMute();
            setState(() {});
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
              ttsService.isMuted ? Icons.volume_off : Icons.volume_up,
              color: isDark ? AppColors.darkInkLight : AppColors.inkLight,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}

class _ManuscriptFeedPageState extends State<ManuscriptFeedPage> {
  final PageController _pageController = PageController();
  final TtsService _ttsService = di.getIt<TtsService>();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkPaperBase : AppColors.paperBase,
      body: BlocBuilder<ManuscriptBloc, ManuscriptState>(
        builder: (context, state) => _buildBody(state),
      ),
    );
  }

  @override
  void dispose() {
    _ttsService.stop();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _ttsService.init();
    context.read<ManuscriptBloc>().add(const LoadManuscriptPages());
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
        ttsService: _ttsService,
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
      _ttsService.stop();
    }
    setState(() => _currentPage = index);
    final state = context.read<ManuscriptBloc>().state;
    if (state is ManuscriptLoaded && index < state.pages.length) {
      final page = state.pages[index];
      _ttsService.speak('${page.title}. ${page.quote}');
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
