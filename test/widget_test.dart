import 'package:carolie_tracking_app/src/screens/home_screen.dart';
import 'package:carolie_tracking_app/src/screens/log_meal_screen.dart';
import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:carolie_tracking_app/src/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the home insight content', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: Padding(padding: EdgeInsets.all(16), child: InsightCard()),
        ),
      ),
    );

    expect(find.text('Fonio Supergrain'), findsOneWidget);
    expect(find.textContaining('Rich in amino acids'), findsOneWidget);
  });

  testWidgets('renders the log meal dish content and navigation bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              DishCard(
                title: 'Jollof Rice',
                subtitle: '~450 cal per serving',
                portions: ['1 plate', '1/2 plate', '1 cup'],
              ),
            ],
          ),
          bottomNavigationBar: AppBottomNavigation(
            currentScreen: AppScreen.logMeal,
            onTabSelected: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Jollof Rice'), findsOneWidget);
    expect(find.text('~450 cal per serving'), findsOneWidget);
    expect(find.text('1 plate'), findsOneWidget);
    expect(find.byKey(const Key('navLogTab')), findsOneWidget);
  });
}
