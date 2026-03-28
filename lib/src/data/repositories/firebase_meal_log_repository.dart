import 'package:carolie_tracking_app/src/core/firebase/firebase_collection_names.dart';
import 'package:carolie_tracking_app/src/data/models/meal_log_model.dart';
import 'package:carolie_tracking_app/src/domain/entities/meal_log.dart';
import 'package:carolie_tracking_app/src/domain/repositories/meal_log_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMealLogRepository implements MealLogRepository {
  FirebaseMealLogRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collectionForUser(String userId) {
    return _firestore
        .collection(FirebaseCollectionNames.users)
        .doc(userId)
        .collection(FirebaseCollectionNames.mealLogs);
  }

  @override
  Future<void> addMealLog(MealLog mealLog) async {
    final model = MealLogModel.fromEntity(mealLog);
    await _collectionForUser(mealLog.userId).doc(mealLog.id).set(model.toMap());
  }

  @override
  Future<void> deleteMealLog({
    required String userId,
    required String mealLogId,
  }) async {
    await _collectionForUser(userId).doc(mealLogId).delete();
  }

  @override
  Future<void> updateMealLog(MealLog mealLog) async {
    final model = MealLogModel.fromEntity(mealLog);
    await _collectionForUser(
      mealLog.userId,
    ).doc(mealLog.id).update(model.toMap());
  }

  @override
  Stream<List<MealLog>> watchMealLogs(String userId) {
    return _collectionForUser(userId)
        .orderBy('loggedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MealLogModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
