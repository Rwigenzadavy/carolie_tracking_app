import 'package:carolie_tracking_app/firebase_options.dart';
import 'package:carolie_tracking_app/src/app.dart';
import 'package:carolie_tracking_app/src/data/repositories/firebase_auth_repository.dart';
import 'package:carolie_tracking_app/src/data/repositories/firebase_community_post_repository.dart';
import 'package:carolie_tracking_app/src/data/repositories/firebase_meal_log_repository.dart';
import 'package:carolie_tracking_app/src/data/repositories/shared_prefs_preferences_repository.dart';
import 'package:carolie_tracking_app/src/domain/repositories/auth_repository.dart';
import 'package:carolie_tracking_app/src/domain/repositories/community_post_repository.dart';
import 'package:carolie_tracking_app/src/domain/repositories/meal_log_repository.dart';
import 'package:carolie_tracking_app/src/domain/repositories/preferences_repository.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/auth_controller.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/community_post_controller.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/meal_log_controller.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/preferences_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefsRepo = SharedPrefsPreferencesRepository();
  final prefsController = PreferencesController(prefsRepo);
  await prefsController.load();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => FirebaseAuthRepository(),
        ),
        Provider<MealLogRepository>(
          create: (_) => FirebaseMealLogRepository(),
        ),
        Provider<CommunityPostRepository>(
          create: (_) => FirebaseCommunityPostRepository(),
        ),
        Provider<PreferencesRepository>(
          create: (_) => prefsRepo,
        ),
        ChangeNotifierProvider<PreferencesController>.value(
          value: prefsController,
        ),
        ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController(context.read<AuthRepository>()),
        ),
        ChangeNotifierProxyProvider2<AuthController, MealLogRepository,
            MealLogController>(
          create: (context) =>
              MealLogController(context.read<MealLogRepository>()),
          update: (_, authController, mealLogRepository, mealLogController) {
            final controller =
                mealLogController ?? MealLogController(mealLogRepository);
            controller.bindUser(authController.currentUser?.id);
            return controller;
          },
        ),
        ChangeNotifierProxyProvider2<AuthController, CommunityPostRepository,
            CommunityPostController>(
          create: (context) =>
              CommunityPostController(context.read<CommunityPostRepository>()),
          update: (_, authController, communityRepo, communityController) {
            final controller =
                communityController ?? CommunityPostController(communityRepo);
            controller.bindUser(authController.currentUser?.id);
            return controller;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}
