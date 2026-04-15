import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:art_of_deal_war/core/theme/app_theme.dart';
import 'package:art_of_deal_war/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_bloc.dart';
import 'package:art_of_deal_war/features/manuscript/presentation/bloc/manuscript_event.dart';

class SettingsBottomSheet extends StatelessWidget {
  final bool showCloseButton;
  final VoidCallback? onClose;

  const SettingsBottomSheet({
    super.key,
    this.showCloseButton = false,
    this.onClose,
  });

  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SettingsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkPaperBase : AppColors.paperBase;
    final textColor = isDark ? AppColors.darkInkLight : AppColors.inkBlack;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.inkLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: showCloseButton
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: GoogleFonts.notoSerif(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      if (showCloseButton && onClose != null)
                        IconButton(
                          icon: Icon(Icons.close, color: textColor),
                          onPressed: onClose,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: 'Language',
                  child: _buildLanguageSelector(context, state),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Theme',
                  child: _buildThemeSelector(context, state),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Audio',
                  child: _buildAudioToggles(context, state),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor = isDark ? AppColors.darkInkGray : AppColors.inkGray;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSansJp(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: subColor,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, SettingsState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark ? AppColors.darkInkLight : AppColors.inkBlack;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: SettingsCubit.supportedLanguages.map((lang) {
        final isSelected = state.language == lang['code'];
        return GestureDetector(
          onTap: () => _onLanguageTap(context, lang['code']!),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.vermillion.withValues(alpha: 0.15)
                  : (isDark ? AppColors.darkPaperAged : AppColors.paperAged),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.vermillion
                    : (isDark ? AppColors.darkInkLight : AppColors.inkLight)
                          .withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              lang['name']!,
              style: GoogleFonts.notoSansJp(
                fontSize: 14,
                color: isSelected ? AppColors.vermillion : selectedColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _onLanguageTap(BuildContext context, String languageCode) async {
    HapticFeedback.selectionClick();
    final settingsCubit = context.read<SettingsCubit>();

    await settingsCubit.setLanguage(languageCode);

    if (context.mounted) {
      final bloc = context.read<ManuscriptBloc>();
      bloc.add(LoadManuscriptPages(language: languageCode));
    }
  }

  Widget _buildThemeSelector(BuildContext context, SettingsState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark ? AppColors.darkInkLight : AppColors.inkBlack;

    return Row(
      children: [
        _ThemeOption(
          icon: Icons.brightness_auto,
          label: 'System',
          isSelected: state.themeMode == ThemeMode.system,
          onTap: () =>
              context.read<SettingsCubit>().setThemeMode(ThemeMode.system),
          color: selectedColor,
        ),
        const SizedBox(width: 12),
        _ThemeOption(
          icon: Icons.light_mode,
          label: 'Light',
          isSelected: state.themeMode == ThemeMode.light,
          onTap: () =>
              context.read<SettingsCubit>().setThemeMode(ThemeMode.light),
          color: selectedColor,
        ),
        const SizedBox(width: 12),
        _ThemeOption(
          icon: Icons.dark_mode,
          label: 'Dark',
          isSelected: state.themeMode == ThemeMode.dark,
          onTap: () =>
              context.read<SettingsCubit>().setThemeMode(ThemeMode.dark),
          color: selectedColor,
        ),
      ],
    );
  }

  Widget _buildAudioToggles(BuildContext context, SettingsState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkInkLight : AppColors.inkBlack;

    return Column(
      children: [
        _SettingsToggle(
          title: 'Background Music',
          subtitle: 'Ambient soundtrack during app use',
          icon: Icons.music_note,
          value: state.backgroundMusicEnabled,
          onChanged: (value) =>
              context.read<SettingsCubit>().setBackgroundMusic(value),
          textColor: textColor,
        ),
        const SizedBox(height: 12),
        _SettingsToggle(
          title: 'TTS Reader',
          subtitle: 'Text-to-speech audio for quotes',
          icon: Icons.record_voice_over,
          value: state.ttsReaderEnabled,
          onChanged: (value) =>
              context.read<SettingsCubit>().setTtsReader(value),
          textColor: textColor,
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.vermillion.withValues(alpha: 0.15)
              : (isDark ? AppColors.darkPaperAged : AppColors.paperAged),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.vermillion
                : (isDark ? AppColors.darkInkLight : AppColors.inkLight)
                      .withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.vermillion : color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.notoSansJp(
                fontSize: 14,
                color: isSelected ? AppColors.vermillion : color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color textColor;

  const _SettingsToggle({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor = isDark ? AppColors.darkInkGray : AppColors.inkGray;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.darkPaperAged : AppColors.paperAged),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: textColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSansJp(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.notoSansJp(fontSize: 12, color: subColor),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: (v) {
            HapticFeedback.selectionClick();
            onChanged(v);
          },
          activeThumbColor: AppColors.vermillion,
        ),
      ],
    );
  }
}
