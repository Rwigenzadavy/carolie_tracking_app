import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

class VoiceInputScreen extends StatefulWidget {
  const VoiceInputScreen({
    super.key,
    required this.onVoiceResult,
    required this.onCancel,
  });

  final void Function(String text) onVoiceResult;
  final VoidCallback onCancel;

  @override
  State<VoiceInputScreen> createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _recognizedText = '';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (error) {
        debugPrint('Speech recognition error: $error');
        if (mounted) {
          setState(() => _isListening = false);
          _pulseController.stop();
        }
      },
      onStatus: (status) {
        debugPrint('Speech recognition status: $status');
        if ((status == 'done' || status == 'notListening') && mounted) {
          setState(() => _isListening = false);
          _pulseController.stop();
        }
      },
    );
    if (mounted) {
      setState(() {});
      if (_speechEnabled) {
        _startListening();
      } else {
        _showPermissionDialog();
      }
    }
  }

  void _startListening() async {
    if (!_speechEnabled) {
      _showPermissionDialog();
      return;
    }
    setState(() {
      _isListening = true;
      _recognizedText = '';
    });
    _pulseController.repeat(reverse: true);

    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: 'en_US',
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
      ),
    );
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
    _pulseController.stop();

    if (_recognizedText.isNotEmpty) {
      widget.onVoiceResult(_recognizedText);
    } else {
      widget.onCancel();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() => _recognizedText = result.recognizedWords);
    if (result.finalResult && _recognizedText.isNotEmpty) {
      _stopListening();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Microphone Permission',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Please enable microphone permission in your device settings to use voice input.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.heroBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Voice Input',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onCancel,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Mic button — vertically centred in the remaining space ──────
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pulsing mic button
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow ring (pulses)
                          Transform.scale(
                            scale: _isListening ? _pulseAnimation.value : 1.0,
                            child: Container(
                              width: 182,
                              height: 182,
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Main orange circle with glow shadow
                          Container(
                            width: 134,
                            height: 134,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.6),
                                  blurRadius: 40,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.mic,
                                color: Colors.white,
                                size: 58,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // "Listening…" label
                  Text(
                    _recognizedText.isNotEmpty
                        ? _recognizedText
                        : 'Listening...',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Speak clearly and mention portion sizes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // ── Stop button ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                height: 57,
                child: OutlinedButton(
                  onPressed: _stopListening,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    side: const BorderSide(color: Colors.white, width: 1.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Stop',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
