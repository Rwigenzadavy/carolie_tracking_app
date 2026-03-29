import 'package:carolie_tracking_app/src/domain/entities/app_user.dart';
import 'package:carolie_tracking_app/src/domain/entities/community_post.dart';
import 'package:carolie_tracking_app/src/domain/repositories/auth_repository.dart';
import 'package:carolie_tracking_app/src/domain/repositories/community_post_repository.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/auth_controller.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/community_post_controller.dart';
import 'package:carolie_tracking_app/src/screens/community_screen.dart';
import 'package:carolie_tracking_app/src/screens/home_screen.dart';
import 'package:carolie_tracking_app/src/screens/log_meal_screen.dart';
import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:carolie_tracking_app/src/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

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
            children: [
              DishCard(
                title: 'Jollof Rice',
                calories: 450,
                portions: ['1 plate', '1/2 plate', '1 cup'],
                onLogPressed: (_) {},
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

  testWidgets('submits a community post from the Tribe sheet', (
    WidgetTester tester,
  ) async {
    final authController = AuthController(_FakeAuthRepository(_testUser));
    final repository = _FakeCommunityPostRepository();
    final communityController = CommunityPostController(repository)
      ..bindUser(_testUser.id);

    addTearDown(authController.dispose);
    addTearDown(communityController.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>.value(value: authController),
          ChangeNotifierProvider<CommunityPostController>.value(
            value: communityController,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: CommunityScreen(onTabSelected: (_) {}),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.byKey(const Key('communityFab')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('communityPostField')),
      'Meal prep is finally getting easier this week.',
    );
    await tester.tap(find.byKey(const Key('communitySubmitPostButton')));
    await tester.pumpAndSettle();

    expect(repository.addedPosts, hasLength(1));
    expect(repository.addedPosts.single.body, contains('Meal prep'));
    expect(find.text('Share with the community'), findsNothing);
  });

  testWidgets('shows feedback instead of silently ignoring an empty post', (
    WidgetTester tester,
  ) async {
    final authController = AuthController(_FakeAuthRepository(_testUser));
    final communityController = CommunityPostController(
      _FakeCommunityPostRepository(),
    )..bindUser(_testUser.id);

    addTearDown(authController.dispose);
    addTearDown(communityController.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>.value(value: authController),
          ChangeNotifierProvider<CommunityPostController>.value(
            value: communityController,
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: CommunityScreen(onTabSelected: (_) {}),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.byKey(const Key('communityFab')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('communitySubmitPostButton')));
    await tester.pump();

    expect(find.text('Write something before posting.'), findsOneWidget);
  });
}

const _testUser = AppUser(
  id: 'user-123',
  email: 'test@example.com',
  displayName: 'Carolie',
  emailVerified: true,
);

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this.user);

  final AppUser? user;

  @override
  Stream<AppUser?> watchAuthState() => Stream<AppUser?>.value(user);

  @override
  Future<void> resendVerificationEmail() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> signInAnonymously() async {}

  @override
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {}
}

class _FakeCommunityPostRepository implements CommunityPostRepository {
  final addedPosts = <CommunityPost>[];

  @override
  Future<void> addPost(CommunityPost post) async {
    addedPosts.add(post);
  }

  @override
  Future<void> likePost(String postId) async {}

  @override
  Stream<List<CommunityPost>> watchPosts() => Stream.value(const []);
}
