import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:carolie_tracking_app/src/utils/meal_copy.dart';
import 'package:carolie_tracking_app/src/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogMealScreen extends StatelessWidget {
  const LogMealScreen({
    super.key,
    required this.onBackPressed,
    required this.onTabSelected,
  });

  final VoidCallback onBackPressed;
  final ValueChanged<AppScreen> onTabSelected;

  static final _dishes = [
    (
      title: 'Jollof Rice',
      subtitle: MealCopy.servingCalories(450),
      portions: ['1 plate', '½ plate', '1 cup'],
    ),
    (
      title: 'Egusi Soup with Fufu',
      subtitle: MealCopy.servingCalories(520),
      portions: ['1 bowl', '½ bowl', '1 wrap'],
    ),
    (
      title: 'Suya (Beef)',
      subtitle: MealCopy.servingCalories(280),
      portions: ['5 sticks', '3 sticks', '100g'],
    ),
    (
      title: 'Moi Moi',
      subtitle: MealCopy.servingCalories(160),
      portions: ['1 wrap', '2 wraps', '100g'],
    ),
    (
      title: 'Pounded Yam',
      subtitle: MealCopy.servingCalories(330),
      portions: ['1 wrap', '½ wrap', '200g'],
    ),
    (
      title: 'Akara (Bean Cake)',
      subtitle: MealCopy.servingCalories(180),
      portions: ['3 pieces', '5 pieces', '1 piece'],
    ),
    (
      title: 'Fried Plantain',
      subtitle: MealCopy.servingCalories(220),
      portions: ['1 medium', '1 large', '5 slices'],
    ),
    (
      title: 'Chin Chin',
      subtitle: MealCopy.servingCalories(140),
      portions: ['1 handful', '1 cup', '50g'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppViewport(
      bottomNavigationBar: AppBottomNavigation(
        currentScreen: AppScreen.logMeal,
        onTabSelected: onTabSelected,
      ),
      child: Column(
        children: [
          _LogMealHero(onBackPressed: onBackPressed),
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
  const _LogMealHero({required this.onBackPressed});

  final VoidCallback onBackPressed;

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
          const _SearchField(),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: ActionPill(
                  assetPath: 'assets/figma/log/scan_icon',
                  label: 'Scan Barcode',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ActionPill(
                  assetPath: 'assets/figma/log/voice_icon',
                  label: 'Voice Input',
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
  const _SearchField();

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
          const Text(
            'Search local dishes...',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
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
    return Row(
      children: const [
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
  const ActionPill({super.key, required this.assetPath, required this.label});

  final String assetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
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
