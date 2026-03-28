import 'package:carolie_tracking_app/src/screens/scan_barcode_screen.dart';
import 'package:carolie_tracking_app/src/screens/voice_input_screen.dart';
import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:carolie_tracking_app/src/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogMealScreen extends StatefulWidget {
  const LogMealScreen({
    super.key,
    required this.onBackPressed,
    required this.onTabSelected,
  });

  final VoidCallback onBackPressed;
  final ValueChanged<AppScreen> onTabSelected;

  @override
  State<LogMealScreen> createState() => _LogMealScreenState();
}

class _LogMealScreenState extends State<LogMealScreen> {
  String? _searchQuery;
  bool _showScanBarcode = false;
  bool _showVoiceInput = false;

  static const _dishes = [
    (
      title: 'Jollof Rice',
      subtitle: '~450 cal per serving',
      portions: ['1 plate', '½ plate', '1 cup'],
    ),
    (
      title: 'Egusi Soup with Fufu',
      subtitle: '~520 cal per serving',
      portions: ['1 bowl', '½ bowl', '1 wrap'],
    ),
    (
      title: 'Suya (Beef)',
      subtitle: '~280 cal per serving',
      portions: ['5 sticks', '3 sticks', '100g'],
    ),
    (
      title: 'Moi Moi',
      subtitle: '~160 cal per serving',
      portions: ['1 wrap', '2 wraps', '100g'],
    ),
    (
      title: 'Pounded Yam',
      subtitle: '~330 cal per serving',
      portions: ['1 wrap', '½ wrap', '200g'],
    ),
    (
      title: 'Akara (Bean Cake)',
      subtitle: '~180 cal per serving',
      portions: ['3 pieces', '5 pieces', '1 piece'],
    ),
    (
      title: 'Fried Plantain',
      subtitle: '~220 cal per serving',
      portions: ['1 medium', '1 large', '5 slices'],
    ),
    (
      title: 'Chin Chin',
      subtitle: '~140 cal per serving',
      portions: ['1 handful', '1 cup', '50g'],
    ),
  ];

  void _openScanBarcode() {
    setState(() {
      _showScanBarcode = true;
    });
  }

  void _openVoiceInput() {
    setState(() {
      _showVoiceInput = true;
    });
  }

  void _closeScanBarcode() {
    setState(() {
      _showScanBarcode = false;
    });
  }

  void _closeVoiceInput() {
    setState(() {
      _showVoiceInput = false;
    });
  }

  void _onBarcodeScanned(String barcode) {
    setState(() {
      _showScanBarcode = false;
      _searchQuery = barcode;
    });
    _showResultSnackBar('Barcode scanned: $barcode');
  }

  void _onVoiceResult(String text) {
    setState(() {
      _showVoiceInput = false;
      _searchQuery = text;
    });
    _showResultSnackBar('Voice input: $text');
  }

  void _showResultSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show Scan Barcode Screen
    if (_showScanBarcode) {
      return ScanBarcodeScreen(
        onBarcodeScanned: _onBarcodeScanned,
        onCancel: _closeScanBarcode,
      );
    }

    // Show Voice Input Screen
    if (_showVoiceInput) {
      return VoiceInputScreen(
        onVoiceResult: _onVoiceResult,
        onCancel: _closeVoiceInput,
      );
    }

    // Main Log Meal Screen
    return AppViewport(
      bottomNavigationBar: AppBottomNavigation(
        currentScreen: AppScreen.logMeal,
        onTabSelected: widget.onTabSelected,
      ),
      child: Column(
        children: [
          _LogMealHero(
            onBackPressed: widget.onBackPressed,
            onScanBarcode: _openScanBarcode,
            onVoiceInput: _openVoiceInput,
            searchQuery: _searchQuery,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              children: [
                const _ResultsHeader(),
                const SizedBox(height: 16),
                ..._dishes.expand(
                  (dish) => [
                    DishCard(
                      title: dish.title,
                      subtitle: dish.subtitle,
                      portions: dish.portions,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogMealHero extends StatelessWidget {
  const _LogMealHero({
    required this.onBackPressed,
    required this.onScanBarcode,
    required this.onVoiceInput,
    this.searchQuery,
  });

  final VoidCallback onBackPressed;
  final VoidCallback onScanBarcode;
  final VoidCallback onVoiceInput;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.heroBackgroundSoft,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            children: [
              IconButton(
                key: const Key('logMealBackButton'),
                onPressed: onBackPressed,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 24,
                  height: 24,
                ),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Log Meal',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SearchField(query: searchQuery),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ActionPill(
                  assetPath: 'assets/figma/log/scan_icon',
                  label: 'Scan Barcode',
                  onTap: onScanBarcode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionPill(
                  assetPath: 'assets/figma/log/voice_icon',
                  label: 'Voice Input',
                  onTap: onVoiceInput,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({this.query});

  final String? query;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.26,
      decoration: BoxDecoration(
        color: AppColors.heroChip,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1AFFFFFF), width: 0.64),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/figma/log/search_icon',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              query ?? 'Search local dishes...',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: query != null ? Colors.white : AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Text(
            'VERIFIED LOCAL DISHES',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1.5,
              letterSpacing: 1,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          '8 results',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

class ActionPill extends StatelessWidget {
  const ActionPill({
    super.key,
    required this.assetPath,
    required this.label,
    this.onTap,
  });

  final String assetPath;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45.26,
        decoration: BoxDecoration(
          color: AppColors.heroChip,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x1AFFFFFF), width: 0.64),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(assetPath, width: 20, height: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DishCard extends StatelessWidget {
  const DishCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.portions,
  });

  final String title;
  final String subtitle;
  final List<String> portions;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 149.72),
      padding: const EdgeInsets.fromLTRB(16.6, 16.6, 16.6, 16.6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.64),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/figma/log/check_icon',
                    width: 12,
                    height: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Select portion:',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: portions
                .map(
                  (portion) => Container(
                    constraints: const BoxConstraints(minHeight: 34),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      portion,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}