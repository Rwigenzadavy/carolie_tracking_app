import 'dart:async';

import 'package:carolie_tracking_app/src/domain/entities/community_post.dart';
import 'package:carolie_tracking_app/src/domain/repositories/community_post_repository.dart';
import 'package:flutter/material.dart';

class CommunityPostController extends ChangeNotifier {
  CommunityPostController(this._repository);

  final CommunityPostRepository _repository;
  StreamSubscription<List<CommunityPost>>? _subscription;

  List<CommunityPost> _posts = const [];
  bool _isLoading = false;
  String? _boundUserId;

  List<CommunityPost> get posts => _posts;
  bool get isLoading => _isLoading;

  void bindUser(String? userId) {
    if (_boundUserId == userId) return;
    _boundUserId = userId;

    _subscription?.cancel();
    _subscription = null;

    if (userId == null) {
      _posts = const [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _subscription = _repository.watchPosts().listen(
      (posts) {
        _posts = posts;
        _isLoading = false;
        notifyListeners();
      },
      onError: (_) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> addPost({
    required String userId,
    required String username,
    required String avatar,
    required String body,
    required String tag,
  }) {
    final now = DateTime.now();
    return _repository.addPost(
      CommunityPost(
        id: now.microsecondsSinceEpoch.toString(),
        userId: userId,
        username: username,
        avatar: avatar,
        body: body,
        tag: tag,
        likes: 0,
        createdAt: now,
      ),
    );
  }

  Future<void> likePost(String postId) => _repository.likePost(postId);

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
