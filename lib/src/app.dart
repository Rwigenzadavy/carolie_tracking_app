import 'package:carolie_tracking_app/src/screens/home_screen.dart';
import 'package:carolie_tracking_app/src/screens/learn_screen.dart';
import 'package:carolie_tracking_app/src/screens/log_meal_screen.dart';
import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:carolie_tracking_app/src/widgets/app_shell.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Tracking App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const CalorieTrackerFlow(),
    );
  }
}

class CalorieTrackerFlow extends StatefulWidget {
  const CalorieTrackerFlow({super.key});

  @override
  State<CalorieTrackerFlow> createState() => _CalorieTrackerFlowState();
}

class _CalorieTrackerFlowState extends State<CalorieTrackerFlow> {
  AppScreen _currentScreen = AppScreen.home;

  void _showScreen(AppScreen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case AppScreen.home:
        return HomeScreen(
          onLogMealPressed: () => _showScreen(AppScreen.logMeal),
          onTabSelected: _showScreen,
        );
      case AppScreen.logMeal:
        return LogMealScreen(
          onBackPressed: () => _showScreen(AppScreen.home),
          onTabSelected: _showScreen,
        );
      case AppScreen.learn:
        return LearnScreen(onTabSelected: _showScreen);
    }
  }
}
