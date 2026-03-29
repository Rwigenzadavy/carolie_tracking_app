import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LessonDetailScreen extends StatelessWidget {
  const LessonDetailScreen({
    super.key,
    required this.emoji,
    required this.category,
    required this.title,
    required this.description,
    required this.readTime,
    required this.content,
  });

  final String emoji;
  final String category;
  final String title;
  final String description;
  final String readTime;
  final List<LessonSection> content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.heroBackground,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.heroBackground,
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        readTime,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...content.map((section) => _SectionWidget(section: section)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LessonSection {
  const LessonSection({required this.heading, required this.body});
  final String heading;
  final String body;
}

class _SectionWidget extends StatelessWidget {
  const _SectionWidget({required this.section});
  final LessonSection section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.heading,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            section.body,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

// Static lesson data used by LearnScreen
class LessonData {
  static final macronutrients = LessonArgs(
    emoji: '📚',
    category: 'Nutrition Basics',
    title: 'Understanding Macronutrients',
    description: 'Learn how carbs, proteins, and fats work in your body',
    readTime: '5 min read',
    content: const [
      LessonSection(
        heading: 'What Are Macronutrients?',
        body:
            'Macronutrients are the three main categories of nutrients your body needs in large amounts: carbohydrates, proteins, and fats. Each plays a distinct and vital role in keeping you energised, building tissue, and supporting bodily functions.',
      ),
      LessonSection(
        heading: 'Carbohydrates — Your Primary Fuel',
        body:
            'Carbs break down into glucose, the brain\'s preferred energy source. Complex carbs like yam, oats, and whole-grain rice digest slowly, giving you sustained energy without blood-sugar spikes. Aim for carbs to make up 45–65 % of your daily calories.',
      ),
      LessonSection(
        heading: 'Proteins — The Body\'s Building Blocks',
        body:
            'Proteins repair and build muscle, produce enzymes and hormones, and support immune health. Great local sources include beans, moi moi, fish, eggs, and lean meat. Target 0.8–1.2 g of protein per kilogram of body weight daily.',
      ),
      LessonSection(
        heading: 'Fats — Essential, Not the Enemy',
        body:
            'Healthy fats from avocado, palm kernel oil (used sparingly), and nuts support brain function, absorb fat-soluble vitamins (A, D, E, K), and regulate hormones. Keep saturated fats below 10 % of total calories and avoid trans fats entirely.',
      ),
      LessonSection(
        heading: 'Balancing Your Plate',
        body:
            'A simple rule: fill half your plate with vegetables, a quarter with a quality protein, and a quarter with a complex carb. Drizzle a small amount of healthy fat on top. This ratio provides all three macros in a culturally adaptable way.',
      ),
    ],
  );

  static final tigerNuts = LessonArgs(
    emoji: '🌰',
    category: 'Local Ingredients',
    title: 'Power of Tiger Nuts',
    description:
        'Discover the health benefits of this ancient African superfood',
    readTime: '4 min read',
    content: const [
      LessonSection(
        heading: 'What Are Tiger Nuts?',
        body:
            'Tiger nuts (Cyperus esculentus), known as aya in Hausa and ofio in Yoruba, are small tubers grown widely across West Africa. Despite the name, they are not nuts — they are root vegetables packed with nutrients.',
      ),
      LessonSection(
        heading: 'Nutritional Profile',
        body:
            'A 30 g serving of dried tiger nuts provides roughly 120 calories, 2 g of protein, 19 g of carbohydrates, and 7 g of fibre. They are rich in vitamins E and C, magnesium, potassium, and resistant starch — a prebiotic that feeds gut bacteria.',
      ),
      LessonSection(
        heading: 'Digestive Health Benefits',
        body:
            'The high fibre and resistant starch content promotes healthy digestion, reduces constipation, and feeds beneficial gut microbiota. Tiger nut milk (kunu aya) is a traditional remedy for stomach upsets and has a naturally low glycaemic index.',
      ),
      LessonSection(
        heading: 'Heart-Healthy Fats',
        body:
            'Tiger nuts contain oleic acid — the same monounsaturated fat found in olive oil — which helps lower LDL ("bad") cholesterol and supports cardiovascular health. This makes them an excellent snack for heart-conscious eaters.',
      ),
      LessonSection(
        heading: 'How to Use Them',
        body:
            'Eat them dried as a snack, soak overnight for a softer texture, blend into kunu aya milk as a dairy-free drink, or grind into flour for baking. Tiger nut flour is also an excellent gluten-free thickener for soups and stews.',
      ),
    ],
  );

  static final jollofRice = LessonArgs(
    emoji: '🍚',
    category: 'Cooking Tips',
    title: 'Healthier Jollof Rice',
    description: 'Enjoy your favourite dish with better nutrition balance',
    readTime: '6 min read',
    content: const [
      LessonSection(
        heading: 'Why Jollof Rice?',
        body:
            'Jollof rice is a cornerstone of West African cuisine — celebrated, debated, and beloved. A standard restaurant portion can exceed 600 calories with high sodium and saturated fat. Small swaps can cut that significantly without sacrificing flavour.',
      ),
      LessonSection(
        heading: 'Choose the Right Rice',
        body:
            'Swap white long-grain rice for parboiled rice or ofada rice. Both have a lower glycaemic index, digest more slowly, and keep you full longer. They also retain more vitamins and minerals than fully milled white rice.',
      ),
      LessonSection(
        heading: 'Cut Back on Palm Oil',
        body:
            'Traditional recipes can call for ½ cup of palm oil per pot. Reducing this to 2–3 tablespoons saves roughly 500 calories per pot and cuts saturated fat significantly. Supplement with a splash of tomato purée for colour and richness.',
      ),
      LessonSection(
        heading: 'Boost the Vegetables',
        body:
            'Add diced carrots, green peas, sweet peppers, and spinach in the last 5 minutes of cooking. This increases fibre, vitamins, and antioxidants while adding very few calories. Aim for vegetables to fill at least 25 % of the pot.',
      ),
      LessonSection(
        heading: 'Protein Pairing',
        body:
            'Pair your jollof with grilled or baked protein instead of fried. Grilled chicken, baked fish, or moi moi keep the meal protein-rich and calorie-controlled. Avoid adding the meat fat drippings back into the rice.',
      ),
      LessonSection(
        heading: 'Portion Control',
        body:
            'Serve jollof on a smaller plate and fill half the plate with a side salad or steamed vegetables first. Research shows this simple technique naturally reduces grain portions by 20–30 % without feeling deprived.',
      ),
    ],
  );
}

class LessonArgs {
  const LessonArgs({
    required this.emoji,
    required this.category,
    required this.title,
    required this.description,
    required this.readTime,
    required this.content,
  });

  final String emoji;
  final String category;
  final String title;
  final String description;
  final String readTime;
  final List<LessonSection> content;
}
