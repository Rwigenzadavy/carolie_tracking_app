import 'package:carolie_tracking_app/src/presentation/controllers/auth_controller.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/meal_log_controller.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/preferences_controller.dart';
import 'package:carolie_tracking_app/src/screens/scan_barcode_screen.dart';
import 'package:carolie_tracking_app/src/screens/voice_input_screen.dart';
import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:carolie_tracking_app/src/widgets/app_shell.dart';
import 'package:carolie_tracking_app/src/widgets/meal_log_editor_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _searchController = TextEditingController();
  bool _showScanBarcode = false;
  bool _showVoiceInput = false;

  static const _dishes = [
    // ── Nigerian dishes ───────────────────────────────────────────────────────
    (
      title: 'Jollof Rice',
      calories: 450,
      portions: ['1 plate', '1/2 plate', '1 cup'],
    ),
    (
      title: 'Egusi Soup with Fufu',
      calories: 520,
      portions: ['1 bowl', '1/2 bowl', '1 wrap'],
    ),
    (
      title: 'Suya (Beef)',
      calories: 280,
      portions: ['5 sticks', '3 sticks', '100g'],
    ),
    (
      title: 'Moi Moi',
      calories: 160,
      portions: ['1 wrap', '2 wraps', '100g'],
    ),
    (
      title: 'Pounded Yam',
      calories: 330,
      portions: ['1 wrap', '1/2 wrap', '200g'],
    ),
    (
      title: 'Akara (Bean Cake)',
      calories: 180,
      portions: ['3 pieces', '5 pieces', '1 piece'],
    ),
    (
      title: 'Fried Plantain',
      calories: 220,
      portions: ['1 medium', '1 large', '5 slices'],
    ),
    (
      title: 'Chin Chin',
      calories: 140,
      portions: ['1 handful', '1 cup', '50g'],
    ),
    // ── Rwandan dishes ────────────────────────────────────────────────────────
    (
      title: 'Ugali (Akacuru)',
      calories: 350,
      portions: ['1 serving', '1/2 serving', '200g'],
    ),
    (
      title: 'Isombe (Cassava Leaves)',
      calories: 180,
      portions: ['1 bowl', '1/2 bowl', '150g'],
    ),
    (
      title: 'Brochettes (Inyama)',
      calories: 260,
      portions: ['5 skewers', '3 skewers', '100g'],
    ),
    (
      title: 'Ibiharage (Beans)',
      calories: 220,
      portions: ['1 bowl', '1/2 bowl', '200g'],
    ),
    (
      title: 'Ibijumba (Sweet Potato)',
      calories: 150,
      portions: ['1 medium', '2 medium', '200g'],
    ),
    (
      title: 'Umutsima (Cassava & Corn)',
      calories: 300,
      portions: ['1 plate', '1/2 plate', '200g'],
    ),
    (
      title: 'Agatogo (Vegetable Stew)',
      calories: 200,
      portions: ['1 bowl', '1/2 bowl', '200g'],
    ),
    (
      title: 'Ibisuma (Sorghum Porridge)',
      calories: 190,
      portions: ['1 cup', '2 cups', '300ml'],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showScanBarcode) {
      return ScanBarcodeScreen(
        onBarcodeScanned: _onBarcodeScanned,
        onCancel: () => setState(() => _showScanBarcode = false),
      );
    }

    if (_showVoiceInput) {
      return VoiceInputScreen(
        onVoiceResult: _onVoiceResult,
        onCancel: () => setState(() => _showVoiceInput = false),
      );
    }

    final query = _searchController.text.trim().toLowerCase();
    final filteredDishes = _dishes.where((dish) {
      return query.isEmpty || dish.title.toLowerCase().contains(query);
    }).toList();

    return AppViewport(
      bottomNavigationBar: AppBottomNavigation(
        currentScreen: AppScreen.logMeal,
        onTabSelected: widget.onTabSelected,
      ),
      child: Column(
        children: [
          _LogMealHero(
            onBackPressed: widget.onBackPressed,
            onScanBarcode: () => setState(() => _showScanBarcode = true),
            onVoiceInput: () => setState(() => _showVoiceInput = true),
            searchController: _searchController,
            onSearchChanged: (_) => setState(() {}),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              children: [
                _ResultsHeader(resultCount: filteredDishes.length),
                const SizedBox(height: 16),
                ...filteredDishes.map(
                  (dish) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DishCard(
                      title: dish.title,
                      calories: dish.calories,
                      portions: dish.portions,
                      onLogPressed: (portion) => _logPresetDish(
                        title: dish.title,
                        calories: dish.calories,
                        portion: portion,
                      ),
                    ),
                  ),
                ),
                if (filteredDishes.isEmpty)
                  const _NoResultsState(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logPresetDish({
    required String title,
    required int calories,
    required String portion,
  }) async {
    final userId = context.read<AuthController>().currentUser?.id;
    if (userId == null) {
      return;
    }

    final result = await showMealLogEditorSheet(
      context,
      suggestedName: title,
      suggestedCalories: calories,
      suggestedMealType: context.read<PreferencesController>().defaultMealType,
      suggestedPortion: portion,
      suggestedSource: 'preset',
    );

    if (result == null || !mounted) {
      return;
    }

    await context.read<MealLogController>().addMealLog(
      userId: userId,
      mealName: result.mealName,
      calories: result.calories,
      mealType: result.mealType,
      portion: result.portion,
      source: result.source,
    );

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal saved to Firestore')),
    );
  }

  Future<void> _onBarcodeScanned(String barcode) async {
    setState(() {
      _showScanBarcode = false;
      _searchController.text = barcode;
    });

    await _openCustomLog(
      suggestedName: 'Scanned item $barcode',
      suggestedSource: 'barcode',
    );
  }

  Future<void> _onVoiceResult(String text) async {
    setState(() {
      _showVoiceInput = false;
      _searchController.text = text;
    });

    await _openCustomLog(
      suggestedName: text,
      suggestedSource: 'voice',
    );
  }

  Future<void> _openCustomLog({
    required String suggestedName,
    required String suggestedSource,
  }) async {
    final userId = context.read<AuthController>().currentUser?.id;
    if (userId == null) {
      return;
    }

    final result = await showMealLogEditorSheet(
      context,
      suggestedName: suggestedName,
      suggestedCalories: 250,
      suggestedMealType: context.read<PreferencesController>().defaultMealType,
      suggestedPortion: '1 serving',
      suggestedSource: suggestedSource,
    );

    if (result == null || !mounted) {
      return;
    }

    await context.read<MealLogController>().addMealLog(
      userId: userId,
      mealName: result.mealName,
      calories: result.calories,
      mealType: result.mealType,
      portion: result.portion,
      source: result.source,
    );

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${result.mealName} saved')),
    );
  }
}

class _LogMealHero extends StatelessWidget {
  const _LogMealHero({
    required this.onBackPressed,
    required this.onScanBarcode,
    required this.onVoiceInput,
    required this.searchController,
    required this.onSearchChanged,
  });

  final VoidCallback onBackPressed;
  final VoidCallback onScanBarcode;
  final VoidCallback onVoiceInput;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

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
                constraints: const BoxConstraints.tightFor(width: 24, height: 24),
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
          _SearchField(
            controller: searchController,
            onChanged: onSearchChanged,
          ),
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
  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.26,
      decoration: BoxDecoration(
        color: AppColors.heroChip,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1AFFFFFF), width: 0.64),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search local dishes...',
          hintStyle: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              'assets/figma/log/search_icon',
              width: 20,
              height: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 20),
        ),
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.resultCount});

  final int resultCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
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
          '$resultCount results',
          style: const TextStyle(
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

class DishCard extends StatefulWidget {
  const DishCard({
    super.key,
    required this.title,
    required this.calories,
    required this.portions,
    required this.onLogPressed,
  });

  final String title;
  final int calories;
  final List<String> portions;
  final ValueChanged<String> onLogPressed;

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> {
  late String _selectedPortion;

  @override
  void initState() {
    super.initState();
    _selectedPortion = widget.portions.first;
  }

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
                  widget.title,
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
            '~${widget.calories} cal per serving',
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
            children: widget.portions.map((portion) {
              final isSelected = _selectedPortion == portion;
              return GestureDetector(
                onTap: () => setState(() => _selectedPortion = portion),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 34),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accentSoft : AppColors.chipBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    portion,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: isSelected ? AppColors.accent : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => widget.onLogPressed(_selectedPortion),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Log this meal'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResultsState extends StatelessWidget {
  const _NoResultsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Text(
        'No preset dishes match your search yet. Try voice or barcode input to log a custom meal.',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
