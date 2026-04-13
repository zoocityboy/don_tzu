import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:art_of_deal_war/core/services/background_music_player.dart';
import 'package:art_of_deal_war/core/theme/app_theme.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/intro_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/intro_state.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/widgets/manuscript_page_card.dart';

const Duration kIntroAnimationDuration = Duration(milliseconds: 1000);

class IntroCoverPage extends StatefulWidget {
  final VoidCallback onEnter;

  const IntroCoverPage({super.key, required this.onEnter});

  @override
  State<IntroCoverPage> createState() => _IntroCoverPageState();
}

class _IntroCoverPageState extends State<IntroCoverPage> {
  bool _showContent = false;
  final _audioPlayer = BackgroundMusicPlayer();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  void _handleEnter(IntroState state) {
    if (state is! IntroReady) return;
    HapticFeedback.mediumImpact();
    _audioPlayer.play('sound/walen-lonely-samurai.mp3');
    widget.onEnter();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paperBase = isDark ? AppColors.darkPaperBase : AppColors.paperBase;
    final inkBlack = isDark ? AppColors.darkInkLight : AppColors.inkBlack;
    final inkGray = isDark ? AppColors.darkInkGray : AppColors.inkGray;

    return BlocBuilder<IntroBloc, IntroState>(
      builder: (context, state) {
        final isReady = state is IntroReady;
        return Scaffold(
          backgroundColor: paperBase,
          body: Stack(
            fit: StackFit.expand,
            children: [
              PaperTextureWidget(isDark: isDark),
              AgedEdgesWidget(isDark: isDark),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Spacer(flex: 1),
                      AnimatedOpacity(
                        opacity: _showContent ? 1.0 : 0.0,
                        duration: kIntroAnimationDuration,
                        child: AnimatedSlide(
                          offset: _showContent
                              ? Offset.zero
                              : const Offset(0, 0.1),
                          duration: kIntroAnimationDuration,
                          curve: Curves.easeOutCubic,
                          child: Column(
                            children: [
                              Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.vermillion,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '戰',
                                      style: GoogleFonts.notoSerifJp(
                                        fontSize: 64,
                                        color: AppColors.vermillion,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                  .animate()
                                  .scale(
                                    begin: const Offset(1.2, 1.2),
                                    end: const Offset(1, 1),
                                    duration: kIntroAnimationDuration,
                                    curve: Curves.easeOutCubic,
                                  )
                                  .fadeIn(duration: 600.ms),
                              const SizedBox(height: 24),
                              Text(
                                    'THE ART OF DEAL WAR',
                                    style: GoogleFonts.notoSerifJp(
                                      fontSize: 28,
                                      color: inkBlack,
                                      fontWeight: FontWeight.w700,
                                      height: 1.3,
                                      letterSpacing: 2,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                  .animate(delay: 200.ms)
                                  .fadeIn(duration: 600.ms)
                                  .slideY(
                                    begin: 0.3,
                                    end: 0,
                                    duration: 600.ms,
                                  ),
                              const SizedBox(height: 8),
                              Container(
                                    width: 80,
                                    height: 2,
                                    color: AppColors.vermillion,
                                  )
                                  .animate(delay: 300.ms)
                                  .fadeIn(duration: 600.ms)
                                  .scaleX(begin: 0, end: 1, duration: 600.ms),
                              const SizedBox(height: 32),
                              Text(
                                    'A 2500 Year Old Discovery',
                                    style: GoogleFonts.notoSerif(
                                      fontSize: 16,
                                      color: inkGray,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                  .animate(delay: 400.ms)
                                  .fadeIn(duration: 600.ms)
                                  .slideY(
                                    begin: 0.2,
                                    end: 0,
                                    duration: 600.ms,
                                  ),
                              const SizedBox(height: 40),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child:
                                    Column(
                                          children: [
                                            _StoryText(
                                              text:
                                                  'In 2024, archeologists uncovered a sealed vault in the Arizona desert containing ancient military scrolls from 250 BC.',
                                              isDark: isDark,
                                            ),
                                            const SizedBox(height: 16),
                                            _StoryText(
                                              text:
                                                  'Among them was "The Art of Deal War" - a strategic military treatise written by Commander-in-Chief Don Tzu.',
                                              isDark: isDark,
                                            ),
                                            const SizedBox(height: 16),
                                            _StoryText(
                                              text:
                                                  'Until now, these pages remained hidden from the public...',
                                              isDark: isDark,
                                            ),
                                          ],
                                        )
                                        .animate(delay: 500.ms)
                                        .fadeIn(duration: 600.ms)
                                        .slideY(
                                          begin: 0.15,
                                          end: 0,
                                          duration: 600.ms,
                                        ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                      AnimatedOpacity(
                        opacity: _showContent ? 1.0 : 0.0,
                        duration: kIntroAnimationDuration,
                        child: isReady
                            ? _buildEnterButton(context, state)
                            : _buildLoadingIndicator(),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        const CircularProgressIndicator(
          color: AppColors.vermillion,
          strokeWidth: 2,
        ),
        const SizedBox(height: 12),
        Text(
          'Preparing audio...',
          style: GoogleFonts.notoSerif(
            fontSize: 14,
            color: AppColors.inkGray,
          ),
        ),
      ],
    );
  }

  Widget _buildEnterButton(BuildContext context, IntroState state) {
    return GestureDetector(
      onTap: () => _handleEnter(state),
      child:
          Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.vermillion,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'OPEN THE SCROLL',
                      style: GoogleFonts.notoSerifJp(
                        fontSize: 16,
                        color: AppColors.vermillion,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.arrow_forward,
                      color: AppColors.vermillion,
                      size: 20,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .shimmer(
                delay: 800.ms,
                duration: 2000.ms,
                color: AppColors.vermillion.withValues(alpha: 0.3),
              ),
    );
  }
}

class _StoryText extends StatelessWidget {
  final String text;
  final bool isDark;

  const _StoryText({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final inkGray = isDark ? AppColors.darkInkGray : AppColors.inkGray;
    return Text(
      text,
      style: GoogleFonts.notoSerif(
        fontSize: 14,
        color: inkGray,
        height: 1.8,
      ),
      textAlign: TextAlign.center,
    );
  }
}
