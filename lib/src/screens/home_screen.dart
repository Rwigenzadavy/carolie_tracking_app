import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:carolie_tracking_app/src/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onLogMealPressed,
    required this.onTabSelected,
  });

  final VoidCallback onLogMealPressed;
  final ValueChanged<AppScreen> onTabSelected;

  static const _meals = [
    (
      imagePath: 'assets/figma/home/millet_image',
      title: 'Millet Porridge',
      subtitle: 'Breakfast • 08:30 AM',
      calories: '320 cal',
    ),
    (
      imagePath: 'assets/figma/home/jollof_image',
      title: 'Jollof Rice & Plantain',
      subtitle: 'Lunch • 01:15 PM',
      calories: '650 cal',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppViewport(
      bottomNavigationBar: AppBottomNavigation(
        currentScreen: AppScreen.home,
        onTabSelected: onTabSelected,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _HomeHero(onLogMealPressed: onLogMealPressed),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'DAILY INSIGHT',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: 1,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: InsightCard(),
                ),
                const SizedBox(height: 26),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "TODAY'S MEALS",
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
                const SizedBox(height: 16),
                ..._meals.expand(
                  (meal) => [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MealEntryCard(
                        imagePath: meal.imagePath,
                        title: meal.title,
                        subtitle: meal.subtitle,
                        calories: meal.calories,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({required this.onLogMealPressed});

  final VoidCallback onLogMealPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.heroBackground,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'MONDAY, OCT 24',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        letterSpacing: 1,
                        color: Color(0xB3FFFFFF),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Hello, Dominion',
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
              ),
              const _HeroActionIcon(
                assetPath: 'assets/figma/home/bell_icon',
                iconSize: 20,
              ),
              const SizedBox(width: 10),
              const _HeroActionIcon(
                assetPath: 'assets/figma/home/profile_icon',
                iconSize: 24,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Calories Left',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.textOnDarkMuted,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
              children: [
                TextSpan(
                  text: '840',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
                TextSpan(
                  text: ' / 2,100 kcal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0x99FFFFFF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const _HeroProgress(value: 0.40),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: MacroCard(value: '124g', label: 'Carbs'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: MacroCard(value: '65g', label: 'Protein'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: MacroCard(value: '42g', label: 'Fat'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: FilledButton(
              key: const Key('homeLogMealButton'),
              onPressed: onLogMealPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/figma/home/log_meal_plus_icon',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Log Meal',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  const InsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 100.98),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 1),
            child: Text('💡', style: TextStyle(fontSize: 20, height: 1.5)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fonio Supergrain',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Rich in amino acids and easy to digest. A great local alternative to quinoa.',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MealEntryCard extends StatelessWidget {
  const MealEntryCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.calories,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String calories;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95.25,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.64),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    Text(
                      calories,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MacroCard extends StatelessWidget {
  const MacroCard({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.5,
      decoration: BoxDecoration(
        color: AppColors.heroCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.textOnDarkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroActionIcon extends StatelessWidget {
  const _HeroActionIcon({required this.assetPath, required this.iconSize});

  final String assetPath;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.heroChip,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0x1AFFFFFF), width: 0.64),
      ),
      child: Center(
        child: SvgPicture.asset(assetPath, width: iconSize, height: iconSize),
      ),
    );
  }
}

class _HeroProgress extends StatelessWidget {
  const _HeroProgress({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
