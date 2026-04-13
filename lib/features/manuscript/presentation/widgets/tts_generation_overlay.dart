import 'package:flutter/material.dart';
import 'package:art_of_deal_war/core/theme/app_theme.dart';
import 'package:art_of_deal_war/core/services/tts_service.dart';
import 'package:art_of_deal_war/core/services/tts_text_model.dart';
import 'package:art_of_deal_war/features/manuscript/data/datasources/manuscript_remote_datasource.dart';
import 'package:art_of_deal_war/injection_container.dart' as di;

class TtsGenerationOverlay {
  static Future<bool> showIfNeeded(
    BuildContext context,
    String languageCode,
  ) async {
    final ttsService = di.getIt<TtsService>();
    final dataSource = di.getIt<ManuscriptRemoteDataSource>();

    if (ttsService.isLanguageReady(languageCode)) {
      return true;
    }

    if (!context.mounted) return false;

    final texts = dataSource.getTtsTexts(languageCode);
    if (texts.isEmpty) return true;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _TtsGenerationDialog(
        languageCode: languageCode,
        texts: texts,
        ttsService: ttsService,
      ),
    );

    return result ?? false;
  }
}

class _TtsGenerationDialog extends StatefulWidget {
  final String languageCode;
  final List<TtsTextModel> texts;
  final TtsService ttsService;

  const _TtsGenerationDialog({
    required this.languageCode,
    required this.texts,
    required this.ttsService,
  });

  @override
  State<_TtsGenerationDialog> createState() => _TtsGenerationDialogState();
}

class _TtsGenerationDialogState extends State<_TtsGenerationDialog> {
  bool _isGenerating = true;
  String _statusMessage = 'Preparing...';

  @override
  void initState() {
    super.initState();
    _generateTts();
  }

  Future<void> _generateTts() async {
    setState(() {
      _statusMessage = 'Generating audio files...';
    });

    try {
      await widget.ttsService.generateForLanguage(
        widget.languageCode,
        widget.texts,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Error: $e';
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkPaperBase : AppColors.paperBase;

    return Dialog(
      backgroundColor: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isGenerating) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Generating Audio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkInkLight : AppColors.inkBlack,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _statusMessage,
                style: TextStyle(
                  color: isDark ? AppColors.darkInkGray : AppColors.inkGray,
                ),
              ),
            ] else ...[
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Failed to generate audio',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? AppColors.darkInkLight : AppColors.inkBlack,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isGenerating = true;
                  });
                  _generateTts();
                },
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
