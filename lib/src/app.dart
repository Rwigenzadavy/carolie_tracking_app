import 'package:carolie_tracking_app/src/screens/login_screen.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/auth_controller.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/preferences_controller.dart';
import 'package:carolie_tracking_app/src/screens/community_screen.dart';
import 'package:carolie_tracking_app/src/screens/home_screen.dart';
import 'package:carolie_tracking_app/src/screens/learn_screen.dart';
import 'package:carolie_tracking_app/src/screens/log_meal_screen.dart';
import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:carolie_tracking_app/src/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<PreferencesController>().isDarkMode;

    return MaterialApp(
      title: 'Calorie Tracking App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, _) {
        if (!authController.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!authController.isAuthenticated) {
          return const LoginScreen();
        }

        return const CalorieTrackerFlow();
      },
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
      case AppScreen.tribe:
        return CommunityScreen(onTabSelected: _showScreen);
    }
  }
}
