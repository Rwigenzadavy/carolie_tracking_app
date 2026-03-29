import 'package:carolie_tracking_app/src/screens/lesson_detail_screen.dart';
import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:carolie_tracking_app/src/widgets/app_shell.dart';
import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key, required this.onTabSelected});

  final ValueChanged<AppScreen> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return AppViewport(
      bottomNavigationBar: AppBottomNavigation(
        currentScreen: AppScreen.learn,
        onTabSelected: onTabSelected,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _LearnHero(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Featured Lessons ──────────────────────────────────
                    const _SectionLabel('FEATURED LESSONS'),
                    const SizedBox(height: 16),
                    _LessonCard(
                      emoji: '📚',
                      iconBg: const Color(0xFFFFF4EC),
                      category: 'Nutrition Basics',
                      title: 'Understanding Macronutrients',
                      description:
                          'Learn how carbs, proteins, and fats work in your body',
                      readTime: '5 min read',
                      onTap: () => _openLesson(context, LessonData.macronutrients),
                    ),
                    const SizedBox(height: 12),
                    _LessonCard(
                      emoji: '🌰',
                      iconBg: const Color(0xFFF0F9FF),
                      category: 'Local Ingredients',
                      title: 'Power of Tiger Nuts',
                      description:
                          'Discover the health benefits of this ancient African superfood',
                      readTime: '4 min read',
                      onTap: () => _openLesson(context, LessonData.tigerNuts),
                    ),
                    const SizedBox(height: 12),
                    _LessonCard(
                      emoji: '🍚',
                      iconBg: const Color(0xFFFEF3F2),
                      category: 'Cooking Tips',
                      title: 'Healthier Jollof Rice',
                      description:
                          'Enjoy your favourite dish with better nutrition balance',
                      readTime: '6 min read',
                      onTap: () => _openLesson(context, LessonData.jollofRice),
                    ),
                    const SizedBox(height: 12),
                    _LessonCard(
                      emoji: '🌿',
                      iconBg: const Color(0xFFE8F5E9),
                      category: 'Rwandan Cuisine',
                      title: 'Isombe — The Leafy Powerhouse',
                      description:
                          'Rwanda\'s beloved cassava-leaf dish is packed with protein and iron',
                      readTime: '5 min read',
                      onTap: () => _openLesson(context, LessonData.isombe),
                    ),
                    const SizedBox(height: 12),
                    _LessonCard(
                      emoji: '🥩',
                      iconBg: const Color(0xFFFFF3E0),
                      category: 'Rwandan Cuisine',
                      title: 'Brochettes — Smart Grilling',
                      description:
                          'How Rwanda\'s favourite street food can fit a balanced diet',
                      readTime: '4 min read',
                      onTap: () => _openLesson(context, LessonData.brochettes),
                    ),
                    const SizedBox(height: 30),

                    // ── Ingredient Spotlight ──────────────────────────────
                    const _SectionHeader(
                      icon: Icons.eco_outlined,
                      label: 'INGREDIENT SPOTLIGHT',
                    ),
                    const SizedBox(height: 16),
                    const _IngredientSpotlightCard(),
                    const SizedBox(height: 30),

                    // ── Seasonal Highlights ───────────────────────────────
                    const _SectionHeader(
                      icon: Icons.wb_sunny_outlined,
                      label: 'SEASONAL HIGHLIGHTS',
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _SeasonalCard(
                            emoji: '🥭',
                            name: 'Mangoes',
                            status: 'Now in season',
                            bg: Color(0xFFFFF4EC),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _SeasonalCard(
                            emoji: '🍠',
                            name: 'Sweet Potato',
                            status: 'Peak season 🇷🇼',
                            bg: Color(0xFFFFF9C4),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _SeasonalCard(
                            emoji: '🌿',
                            name: 'Cassava Leaves',
                            status: 'Available now 🇷🇼',
                            bg: Color(0xFFF0FDF4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _SeasonalCard(
                            emoji: '🍆',
                            name: 'Garden Eggs',
                            status: 'Peak season 🇳🇬',
                            bg: Color(0xFFF0F9FF),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _SeasonalCard(
                            emoji: '🫘',
                            name: 'Ibiharage',
                            status: 'Harvest time 🇷🇼',
                            bg: Color(0xFFE8F5E9),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _SeasonalCard(
                            emoji: '🥥',
                            name: 'Coconuts',
                            status: 'Available now',
                            bg: Color(0xFFFCE4EC),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openLesson(BuildContext context, LessonArgs lesson) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LessonDetailScreen(
          emoji: lesson.emoji,
          category: lesson.category,
          title: lesson.title,
          description: lesson.description,
          readTime: lesson.readTime,
          content: lesson.content,
        ),
      ),
    );
  }
}

// ── Hero ──────────────────────────────────────────────────────────────────────

class _LearnHero extends StatelessWidget {
  const _LearnHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.heroBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Learn',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nutrition education rooted in your culture',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section labels ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  static const _style = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    height: 1.5,
    color: Color(0xFF666666),
  );

  @override
  Widget build(BuildContext context) => Text(text, style: _style);
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF666666)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            height: 1.5,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}

// ── Lesson card ───────────────────────────────────────────────────────────────

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.emoji,
    required this.iconBg,
    required this.category,
    required this.title,
    required this.description,
    required this.readTime,
    required this.onTap,
  });

  final String emoji;
  final Color iconBg;
  final String category;
  final String title;
  final String description;
  final String readTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE), width: 0.64),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    readTime,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF999999)),
          ],
        ),
      ),
    );
  }
}

// ── Ingredient Spotlight ──────────────────────────────────────────────────────

class _IngredientSpotlightCard extends StatelessWidget {
  const _IngredientSpotlightCard();

  static const _bullets = [
    'Boosts immunity',
    'Reduces inflammation',
    'Supports bone health',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF0FDF4), Color(0xFFDCFCE7)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              text: '🌿',
              style: TextStyle(fontSize: 40),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Moringa',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.5,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'The Miracle Tree',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: Color(0xFF16A34A),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Packed with vitamins A, C, and E. Contains more iron than spinach and more calcium than milk.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.54,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 16),
          ..._bullets.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF16A34A),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Color(0xFF444444),
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

// ── Seasonal card ─────────────────────────────────────────────────────────────

class _SeasonalCard extends StatelessWidget {
  const _SeasonalCard({
    required this.emoji,
    required this.name,
    required this.status,
    required this.bg,
  });

  final String emoji;
  final String name;
  final String status;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}
