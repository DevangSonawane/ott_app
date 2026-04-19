import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../theme/app_colors.dart';

class VoiceSearchButton extends ConsumerStatefulWidget {
  const VoiceSearchButton({
    super.key,
    required this.onResult,
    this.onInterimResult,
    this.onListeningChanged,
  });

  final ValueChanged<String> onResult;
  final ValueChanged<String>? onInterimResult;
  final ValueChanged<bool>? onListeningChanged;

  @override
  ConsumerState<VoiceSearchButton> createState() => _VoiceSearchButtonState();
}

class _VoiceSearchButtonState extends ConsumerState<VoiceSearchButton> {
  final SpeechToText _speech = SpeechToText();

  bool _isListening = false;
  bool _didInit = false;
  bool _isAvailable = false;
  bool _busy = false;

  void _setListening(bool value) {
    if (_isListening == value) return;
    setState(() => _isListening = value);
    widget.onListeningChanged?.call(value);
  }

  void _showMicRequiredSnackBar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Microphone permission required for voice search.'),
      ),
    );
  }

  void _showSettingsSnackBar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Microphone permission required for voice search.'),
        action: SnackBarAction(
          label: 'Settings',
          textColor: AppColors.accent,
          onPressed: openAppSettings,
        ),
      ),
    );
  }

  Future<bool> _ensurePermissions() async {
    if (kIsWeb) return true;

    final micStatus = await Permission.microphone.status;
    if (micStatus.isPermanentlyDenied || micStatus.isRestricted) {
      _showSettingsSnackBar();
      return false;
    }

    final mic = await Permission.microphone.request();
    if (!mic.isGranted) {
      if (mic.isPermanentlyDenied || mic.isRestricted) {
        _showSettingsSnackBar();
        return false;
      }
      _showMicRequiredSnackBar();
      return false;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final speechStatus = await Permission.speech.status;
      if (speechStatus.isPermanentlyDenied || speechStatus.isRestricted) {
        _showSettingsSnackBar();
        return false;
      }
      final speech = await Permission.speech.request();
      if (!speech.isGranted) {
        if (speech.isPermanentlyDenied || speech.isRestricted) {
          _showSettingsSnackBar();
          return false;
        }
        _showMicRequiredSnackBar();
        return false;
      }
    }

    return true;
  }

  Future<bool> _ensureSpeechReady() async {
    if (_didInit) return _isAvailable;
    _didInit = true;
    try {
      _isAvailable = await _speech.initialize(
        onError: (_) {
          _setListening(false);
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            _setListening(false);
          }
        },
      );
      return _isAvailable;
    } catch (_) {
      _isAvailable = false;
      return false;
    }
  }

  Future<void> _startListening() async {
    if (_busy) return;
    _busy = true;
    try {
      final hasPerms = await _ensurePermissions();
      if (!hasPerms) {
        return;
      }

      final ready = await _ensureSpeechReady();
      if (!ready) {
        _showMicRequiredSnackBar();
        return;
      }

      _setListening(true);
      await _speech.listen(
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        listenMode: ListenMode.search,
        listenOptions: SpeechListenOptions(
          partialResults: true,
          listenMode: ListenMode.dictation,
          cancelOnError: true,
        ),
        partialResults: true,
        onResult: (result) async {
          final words = result.recognizedWords.trim();
          if (!result.finalResult) {
            widget.onInterimResult?.call(words);
            return;
          }

          widget.onResult(words);
          await _stopListening();
        },
      );
    } catch (_) {
      _showMicRequiredSnackBar();
      _setListening(false);
    } finally {
      _busy = false;
    }
  }

  Future<void> _stopListening() async {
    try {
      await _speech.stop();
    } catch (_) {
      // Ignore
    } finally {
      _setListening(false);
    }
  }

  @override
  void dispose() {
    try {
      _speech.cancel();
    } catch (_) {
      // Ignore
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = Icon(
      _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
      color: _isListening ? AppColors.accent : AppColors.textMuted,
    );

    if (_isListening) {
      icon = icon
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.15, 1.15),
            duration: 600.ms,
            curve: Curves.easeInOut,
          );
    }

    return IconButton(
      onPressed: _isListening ? _stopListening : _startListening,
      icon: icon,
    );
  }
}
