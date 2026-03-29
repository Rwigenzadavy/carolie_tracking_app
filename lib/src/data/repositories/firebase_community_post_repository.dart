import 'package:carolie_tracking_app/src/core/firebase/firebase_collection_names.dart';
import 'package:carolie_tracking_app/src/data/models/community_post_model.dart';
import 'package:carolie_tracking_app/src/domain/entities/community_post.dart';
import 'package:carolie_tracking_app/src/domain/repositories/community_post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCommunityPostRepository implements CommunityPostRepository {
  FirebaseCommunityPostRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirebaseCollectionNames.communityPosts);

  @override
  Stream<List<CommunityPost>> watchPosts() {
    return _collection
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CommunityPostModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Future<void> addPost(CommunityPost post) async {
    final model = CommunityPostModel.fromEntity(post);
    await _collection.doc(post.id).set(model.toMap());
  }

  @override
  Future<void> likePost(String postId) async {
    await _collection.doc(postId).update({
      'likes': FieldValue.increment(1),
    });
  }
}
