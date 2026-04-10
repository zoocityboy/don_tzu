import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../main.dart' show clearCache;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../domain/entities/manuscript_page.dart';
import '../bloc/manuscript_bloc.dart';
import '../bloc/manuscript_event.dart';
import '../bloc/manuscript_state.dart';
import '../widgets/manuscript_page_card.dart';

class ManuscriptFeedPage extends StatefulWidget {
  const ManuscriptFeedPage({super.key});

  @override
  State<ManuscriptFeedPage> createState() => _ManuscriptFeedPageState();
}

class _ManuscriptFeedPageState extends State<ManuscriptFeedPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    context.read<ManuscriptBloc>().add(const LoadManuscriptPages());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _onLike(String pageId) {
    HapticFeedback.lightImpact();
    context.read<ManuscriptBloc>().add(ToggleLike(pageId));
  }

  Future<void> _sharePage(ManuscriptPage page) async {
    final text =
        '''${page.title}

"${page.quote}"

— The Art of Deal War

Shared from The Art of Deal War app''';
    await Share.share(text);
  }

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
      ),
      _ => const LoadingWidget(),
    };
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

class CenteredLayout extends StatelessWidget {
  final List<ManuscriptPage> pages;
  final int currentPage;
  final PageController pageController;
  final void Function(int) onPageChanged;
  final void Function(String) onLike;
  final void Function(ManuscriptPage) onShare;

  const CenteredLayout({
    super.key,
    required this.pages,
    required this.currentPage,
    required this.pageController,
    required this.onPageChanged,
    required this.onLike,
    required this.onShare,
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
              top: constraints.maxHeight * 0.02,
              left: 0,
              right: 0,
              child: PageIndicatorWidget(
                totalPages: pages.length,
                currentPage: currentPage,
              ),
            ),
            Positioned(
              top: constraints.maxHeight * 0.02,
              right: 16,
              child: const ThemeToggleButton(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: constraints.maxHeight * 0.04,
              child: ActionBarWidget(
                page: pages[currentPage],
                onLike: () => onLike(pages[currentPage].id),
                onShare: () => onShare(pages[currentPage]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PageContentWidget extends StatelessWidget {
  final ManuscriptPage page;
  final VoidCallback onLike;
  final VoidCallback onShare;

  const PageContentWidget({
    super.key,
    required this.page,
    required this.onLike,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        HapticFeedback.mediumImpact();
        onLike();
      },
      behavior: HitTestBehavior.opaque,
      child: ManuscriptPageCard(
        page: page,
        onLikeToggle: onLike,
        onShare: onShare,
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
        context.read<ThemeProvider>().toggleTheme();
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
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.vermillion.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
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
            color: AppColors.inkLight.withValues(alpha: 0.2),
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
            color: AppColors.inkLight.withValues(alpha: 0.2),
          ),
          const SealStampWidget(),
        ],
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

class SealStampWidget extends StatelessWidget {
  const SealStampWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        HapticFeedback.heavyImpact();
        await clearCache();
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
