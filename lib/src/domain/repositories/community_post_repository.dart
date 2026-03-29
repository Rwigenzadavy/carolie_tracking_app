import 'package:carolie_tracking_app/src/domain/entities/community_post.dart';

abstract class CommunityPostRepository {
  Stream<List<CommunityPost>> watchPosts();
  Future<void> addPost(CommunityPost post);
  Future<void> likePost(String postId);
}
