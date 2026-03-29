import 'package:carolie_tracking_app/src/domain/entities/community_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPostModel extends CommunityPost {
  const CommunityPostModel({
    required super.id,
    required super.userId,
    required super.username,
    required super.avatar,
    required super.body,
    required super.tag,
    required super.likes,
    required super.createdAt,
  });

  factory CommunityPostModel.fromEntity(CommunityPost post) {
    return CommunityPostModel(
      id: post.id,
      userId: post.userId,
      username: post.username,
      avatar: post.avatar,
      body: post.body,
      tag: post.tag,
      likes: post.likes,
      createdAt: post.createdAt,
    );
  }

  factory CommunityPostModel.fromMap(Map<String, dynamic> map, String id) {
    return CommunityPostModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      username: map['username'] as String? ?? 'Anonymous',
      avatar: map['avatar'] as String? ?? '🧑',
      body: map['body'] as String? ?? '',
      tag: map['tag'] as String? ?? 'General',
      likes: (map['likes'] as num?)?.toInt() ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'avatar': avatar,
      'body': body,
      'tag': tag,
      'likes': likes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
