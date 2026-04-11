import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:art_of_deal_war/core/theme/app_theme.dart';
import 'package:art_of_deal_war/features/manuscript/domain/entities/manuscript_page.dart';

const Duration kAnimationDuration = Duration(milliseconds: 1000);

class AgedEdgesWidget extends StatelessWidget {
  final bool isDark;

  const AgedEdgesWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final agedBrown = isDark ? AppColors.darkPaperDark : AppColors.agedBrown;
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Colors.transparent,
                agedBrown.withValues(alpha: 0.1),
                agedBrown.withValues(alpha: 0.2),
              ],
              stops: const [0.5, 0.8, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

class CenterAuthorWidget extends StatelessWidget {
  final Color color;

  const CenterAuthorWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('* * *', style: GoogleFonts.notoSerif(color: color, fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          'Don Tzu',
          style: GoogleFonts.notoSerif(
            fontSize: 18,
            color: color,
            height: 2.0,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class CenteredQuoteWidget extends StatelessWidget {
  final String quote;
  final Color inkGray;

  const CenteredQuoteWidget({
    super.key,
    required this.quote,
    required this.inkGray,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      // decoration: BoxDecoration(
      //   border: Border.all(color: inkGray.withValues(alpha: 0.15), width: 1),
      //   borderRadius: BorderRadius.circular(8),
      // ),
      child: Text(
        quote,
        style: GoogleFonts.notoSerif(
          fontSize: 18,
          color: inkGray,
          height: 2.0,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class CenteredTitleWidget extends StatelessWidget {
  final String title;
  final Color inkBlack;

  const CenteredTitleWidget({
    super.key,
    required this.title,
    required this.inkBlack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: GoogleFonts.notoSerifJp(
            fontSize: 22,
            color: inkBlack,
            fontWeight: FontWeight.w700,
            height: 1.4,
            letterSpacing: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 2,
          decoration: BoxDecoration(
            color: AppColors.vermillion,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }
}

class AnimatedTextContentWidget extends StatefulWidget {
  final String title;
  final String quote;
  final Color inkBlack;
  final Color inkGray;
  final bool isDark;
  final bool animate;

  const AnimatedTextContentWidget({
    super.key,
    required this.title,
    required this.quote,
    required this.inkBlack,
    required this.inkGray,
    required this.isDark,
    this.animate = true,
  });

  @override
  State<AnimatedTextContentWidget> createState() =>
      _AnimatedTextContentWidgetState();
}

class _AnimatedTextContentWidgetState extends State<AnimatedTextContentWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: kAnimationDuration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(AnimatedTextContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FractionalTranslation(
          translation: _slideAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildContent(),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        spacing: 32,
        children: [
          CenteredTitleWidget(title: widget.title, inkBlack: widget.inkBlack),
          CenteredQuoteWidget(quote: widget.quote, inkGray: widget.inkGray),
          CenterAuthorWidget(color: widget.inkGray),
        ],
      ),
    );
  }
}

class AnimatedCharacterImageWidget extends StatefulWidget {
  final ManuscriptPage page;
  final bool isDark;
  final bool animate;

  const AnimatedCharacterImageWidget({
    super.key,
    required this.page,
    required this.isDark,
    this.animate = true,
  });

  @override
  State<AnimatedCharacterImageWidget> createState() =>
      _AnimatedCharacterImageWidgetState();
}

class _AnimatedCharacterImageWidgetState
    extends State<AnimatedCharacterImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: kAnimationDuration,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.025,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _scaleAnimation = Tween<double>(
      begin: 1.2,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(AnimatedCharacterImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.page.imageAsset.isEmpty) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: RotationTransition(
            turns: _rotationAnimation,
            child: _buildImage(context),
          ),
        );
      },
    );
  }

  Widget _buildImage(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(<double>[
              0.9,
              0.1,
              0.1,
              0,
              widget.isDark ? 20 : 50,
              0.1,
              0.7,
              0.1,
              0,
              widget.isDark ? 10 : 30,
              0.1,
              0.1,
              0.6,
              0,
              widget.isDark ? 5 : 20,
              0,
              0,
              0,
              1,
              0,
            ]),
            child: Opacity(
              opacity: widget.isDark ? 0.08 : 0.25,
              child: Image.asset(
                widget.page.imageAsset,
                fit: BoxFit.cover,
                height: constraints.maxHeight,
                cacheHeight:
                    constraints.maxHeight.toInt() *
                    MediaQuery.of(context).devicePixelRatio.toInt(),
                errorBuilder: (context, error, stack) =>
                    const SizedBox.shrink(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CharacterImageWidget extends StatelessWidget {
  final ManuscriptPage page;
  final bool isDark;

  const CharacterImageWidget({
    super.key,
    required this.page,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (page.imageAsset.isEmpty) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(<double>[
              0.9,
              0.1,
              0.1,
              0,
              isDark ? 20 : 50,
              0.1,
              0.7,
              0.1,
              0,
              isDark ? 10 : 30,
              0.1,
              0.1,
              0.6,
              0,
              isDark ? 5 : 20,
              0,
              0,
              0,
              1,
              0,
            ]),
            child: Opacity(
              opacity: isDark ? 0.08 : 0.25,
              child: Image.asset(
                page.imageAsset,
                fit: BoxFit.cover,
                height: constraints.maxHeight,
                errorBuilder: (context, error, stack) =>
                    const SizedBox.shrink(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ManuscriptPageCard extends StatelessWidget {
  final ManuscriptPage page;
  final VoidCallback onLikeToggle;
  final VoidCallback onShare;

  const ManuscriptPageCard({
    super.key,
    required this.page,
    required this.onLikeToggle,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paperBase = isDark ? AppColors.darkPaperBase : AppColors.paperBase;
    final inkBlack = isDark ? AppColors.darkInkLight : AppColors.inkBlack;
    final inkGray = isDark ? AppColors.darkInkGray : AppColors.inkGray;

    return ColoredBox(
      color: paperBase,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PaperTextureWidget(isDark: isDark),
          AgedEdgesWidget(isDark: isDark),
          CharacterImageWidget(page: page, isDark: isDark),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                spacing: 32,
                children: [
                  CenteredTitleWidget(title: page.title, inkBlack: inkBlack),
                  CenteredQuoteWidget(quote: page.quote, inkGray: inkGray),
                  CenterAuthorWidget(color: inkGray),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaperTextureWidget extends StatelessWidget {
  final bool isDark;

  const PaperTextureWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.darkPaperDark : AppColors.agedBrown;
    return Positioned.fill(
      child: CustomPaint(painter: _PaperTexturePainter(color)),
    );
  }
}

class _PaperTexturePainter extends CustomPainter {
  final Color color;

  const _PaperTexturePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.025)
      ..style = PaintingStyle.fill;

    final random = Random(42);
    for (int i = 0; i < 300; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.3;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    final fiberPaint = Paint()
      ..color = color.withValues(alpha: 0.02)
      ..strokeWidth = 0.4
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 30; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final length = random.nextDouble() * 30 + 15;
      final angle = random.nextDouble() * 0.2 - 0.1;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX + _cos(angle) * length, startY + _sin(angle) * length),
        fiberPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  double _cos(double angle) => (angle * 180 / pi).abs() < 90 ? 1.0 : -1.0;
  double _sin(double angle) => (angle * 180 / pi) > 0 ? 1.0 : -1.0;
}
