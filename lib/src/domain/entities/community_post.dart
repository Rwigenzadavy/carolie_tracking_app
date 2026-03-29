class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.body,
    required this.tag,
    required this.likes,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String username;
  final String avatar;
  final String body;
  final String tag;
  final int likes;
  final DateTime createdAt;
}
