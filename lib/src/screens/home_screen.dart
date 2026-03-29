import 'package:carolie_tracking_app/src/domain/entities/meal_log.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/auth_controller.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/meal_log_controller.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/preferences_controller.dart';
import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:carolie_tracking_app/src/widgets/app_shell.dart';
import 'package:carolie_tracking_app/src/widgets/meal_log_editor_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onLogMealPressed,
    required this.onTabSelected,
  });

  final VoidCallback onLogMealPressed;
  final ValueChanged<AppScreen> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final mealLogController = context.watch<MealLogController>();
    final prefsController = context.watch<PreferencesController>();
    final user = authController.currentUser;
    final totalCalories = mealLogController.totalCalories;
    final calorieGoal = prefsController.calorieGoal;
    final caloriesLeft = (calorieGoal - totalCalories).clamp(0, calorieGoal);
    final progress = (totalCalories / calorieGoal).clamp(0.0, 1.0);

    return AppViewport(
      bottomNavigationBar: AppBottomNavigation(
        currentScreen: AppScreen.home,
        onTabSelected: onTabSelected,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _HomeHero(
            displayName: _firstName(user?.displayName),
            totalCalories: totalCalories,
            caloriesLeft: caloriesLeft,
            calorieGoal: calorieGoal,
            progress: progress,
            onLogMealPressed: onLogMealPressed,
            onSettingsPressed: () => _openSettings(context),
          ),
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
                if (mealLogController.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (mealLogController.mealLogs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _EmptyMealsState(),
                  )
                else
                  ...mealLogController.mealLogs.map(
                    (mealLog) => Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: MealEntryCard(
                        mealLog: mealLog,
                        onEditPressed: () => _editMeal(context, mealLog),
                        onDeletePressed: () => _deleteMeal(context, mealLog),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _SettingsSheet(),
    );
  }

  Future<void> _editMeal(BuildContext context, MealLog mealLog) async {
    final result = await showMealLogEditorSheet(context, mealLog: mealLog);
    if (result == null || !context.mounted) return;

    await context.read<MealLogController>().updateMealLog(
          mealLog.copyWith(
            mealName: result.mealName,
            calories: result.calories,
            mealType: result.mealType,
            portion: result.portion,
            source: result.source,
          ),
        );

    if (!context.mounted) return;
    _showSnackBar(context, 'Meal updated');
  }

  Future<void> _deleteMeal(BuildContext context, MealLog mealLog) async {
    await context.read<MealLogController>().deleteMealLog(mealLog);
    if (!context.mounted) return;
    _showSnackBar(context, 'Meal deleted');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static String _firstName(String? displayName) {
    final cleaned = (displayName ?? 'there').trim();
    if (cleaned.isEmpty) return 'there';
    return cleaned.split(' ').first;
  }
}

// ── Settings Sheet ─────────────────────────────────────────────────────────────

class _SettingsSheet extends StatefulWidget {
  const _SettingsSheet();

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late TextEditingController _calorieGoalController;
  late String _selectedMealType;
  late bool _isDarkMode;

  static const _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  @override
  void initState() {
    super.initState();
    final prefs = context.read<PreferencesController>();
    _calorieGoalController =
        TextEditingController(text: prefs.calorieGoal.toString());
    _selectedMealType = prefs.defaultMealType;
    _isDarkMode = prefs.isDarkMode;
  }

  @override
  void dispose() {
    _calorieGoalController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final prefs = context.read<PreferencesController>();
    final goal = int.tryParse(_calorieGoalController.text.trim());
    if (goal != null && goal > 0) {
      await prefs.setCalorieGoal(goal);
    }
    await prefs.setDefaultMealType(_selectedMealType);
    await prefs.setIsDarkMode(_isDarkMode);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Settings',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Calorie goal
          const Text(
            'Daily Calorie Goal',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _calorieGoalController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '2100',
              suffixText: 'kcal',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),

          // Default meal type
          const Text(
            'Default Meal Type',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedMealType, // ignore: deprecated_member_use
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            items: _mealTypes
                .map((type) =>
                    DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedMealType = value);
            },
          ),
          const SizedBox(height: 16),

          // Dark mode
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Switch(
                value: _isDarkMode,
                activeThumbColor: AppColors.accent,
                onChanged: (value) => setState(() => _isDarkMode = value),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Save Preferences',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Sign out
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await context.read<AuthController>().signOut();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.divider),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero ───────────────────────────────────────────────────────────────────────

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.displayName,
    required this.totalCalories,
    required this.caloriesLeft,
    required this.calorieGoal,
    required this.progress,
    required this.onLogMealPressed,
    required this.onSettingsPressed,
  });

  final String displayName;
  final int totalCalories;
  final num caloriesLeft;
  final int calorieGoal;
  final double progress;
  final VoidCallback onLogMealPressed;
  final VoidCallback onSettingsPressed;

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
                  children: [
                    Text(
                      _todayLabel(),
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        letterSpacing: 1,
                        color: Color(0xB3FFFFFF),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hello, $displayName',
                      style: const TextStyle(
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
              InkWell(
                onTap: onSettingsPressed,
                borderRadius: BorderRadius.circular(20),
                child: const _HeroActionIcon(
                  assetPath: 'assets/figma/home/profile_icon',
                  iconSize: 24,
                ),
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
            text: TextSpan(
              style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
              children: [
                TextSpan(
                  text: '$caloriesLeft',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
                TextSpan(
                  text: ' / $calorieGoal kcal',
                  style: const TextStyle(
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
          _HeroProgress(value: progress),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: MacroCard(
                    value: '${(totalCalories * 0.45).round()}g',
                    label: 'Carbs'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MacroCard(
                    value: '${(totalCalories * 0.25).round()}g',
                    label: 'Protein'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MacroCard(
                    value: '${(totalCalories * 0.15).round()}g',
                    label: 'Fat'),
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

  static String _todayLabel() {
    const weekdays = [
      'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY',
      'FRIDAY', 'SATURDAY', 'SUNDAY',
    ];
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    final now = DateTime.now();
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }
}

// ── Insight Card ───────────────────────────────────────────────────────────────

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

// ── Meal Entry Card ────────────────────────────────────────────────────────────

class MealEntryCard extends StatelessWidget {
  const MealEntryCard({
    super.key,
    required this.mealLog,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final MealLog mealLog;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

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
              'assets/figma/home/jollof_image',
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
                        mealLog.mealName,
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
                      '${mealLog.calories} cal',
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
                  '${mealLog.mealType} • ${mealLog.portion} • ${_formatTime(mealLog.loggedAt)}',
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
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                onEditPressed();
              } else {
                onDeletePressed();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime value) {
    final hour =
        value.hour == 0 ? 12 : (value.hour > 12 ? value.hour - 12 : value.hour);
    final minute = value.minute.toString().padLeft(2, '0');
    final suffix = value.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}

// ── Empty State ────────────────────────────────────────────────────────────────

class _EmptyMealsState extends StatelessWidget {
  const _EmptyMealsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: AppColors.divider),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No meals logged yet',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Use the Log Meal button to create your first Firestore-backed meal entry.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Macro Card ─────────────────────────────────────────────────────────────────

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

// ── Hero Action Icon ───────────────────────────────────────────────────────────

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

// ── Hero Progress ──────────────────────────────────────────────────────────────

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
