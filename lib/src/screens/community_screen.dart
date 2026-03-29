import 'package:carolie_tracking_app/src/domain/entities/community_post.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/auth_controller.dart';
import 'package:carolie_tracking_app/src/presentation/controllers/community_post_controller.dart';
import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:carolie_tracking_app/src/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _groups = [
  (emoji: '🇳🇬', name: 'Nigerian Wellness', members: '2.4k', color: Color(0xFFFFF3E0)),
  (emoji: '🇷🇼', name: 'Rwanda Wellness', members: '1.2k', color: Color(0xFFE8F5E9)),
  (emoji: '🥗', name: 'Fitness & Nutrition', members: '1.8k', color: Color(0xFFE3F2FD)),
  (emoji: '🧘', name: 'Mindful Eating', members: '3.1k', color: Color(0xFFF3E5F5)),
  (emoji: '🏃', name: 'Active Lifestyle', members: '980', color: Color(0xFFFFF9C4)),
];

const _tags = [
  'Nigerian Wellness',
  'Rwanda Wellness',
  'Fitness & Nutrition',
  'Mindful Eating',
  'Active Lifestyle',
];

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key, required this.onTabSelected});

  final ValueChanged<AppScreen> onTabSelected;

  void _openNewPostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _NewPostSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final communityController = context.watch<CommunityPostController>();

    return AppViewport(
      bottomNavigationBar: AppBottomNavigation(
        currentScreen: AppScreen.tribe,
        onTabSelected: onTabSelected,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CommunityHeader(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'YOUR GROUPS',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 130,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _groups.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final g = _groups[index];
                          return _GroupCard(
                            emoji: g.emoji,
                            name: g.name,
                            members: g.members,
                            color: g.color,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'COMMUNITY FEED',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (communityController.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (communityController.posts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: _EmptyPostsState(),
                      )
                    else
                      ...communityController.posts.map(
                        (post) => Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                          child: _PostCard(post: post),
                        ),
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              key: const Key('communityFab'),
              onPressed: () => _openNewPostSheet(context),
              backgroundColor: AppColors.accent,
              elevation: 4,
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}

// ── New Post Sheet ─────────────────────────────────────────────────────────────

class _NewPostSheet extends StatefulWidget {
  const _NewPostSheet();

  @override
  State<_NewPostSheet> createState() => _NewPostSheetState();
}

class _NewPostSheetState extends State<_NewPostSheet> {
  final _controller = TextEditingController();
  String _selectedTag = _tags.first;
  bool _isPosting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    final body = _controller.text.trim();
    if (body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write something before posting.')),
      );
      return;
    }

    setState(() => _isPosting = true);

    try {
      final authController = context.read<AuthController>();
      final communityController = context.read<CommunityPostController>();
      final user = authController.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You must be signed in to post.')),
          );
          setState(() => _isPosting = false);
        }
        return;
      }
      await communityController.addPost(
        userId: user.id,
        username: user.displayName.isNotEmpty ? user.displayName : 'Anonymous',
        avatar: _avatarFor(user.displayName),
        body: body,
        tag: _selectedTag,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post: ${e.toString()}')),
        );
        setState(() => _isPosting = false);
      }
    }
  }

  static String _avatarFor(String name) {
    const avatars = ['🧑🏾', '👩🏽', '🧔🏿', '👨🏻', '👩🏼', '🧑🏿'];
    if (name.isEmpty) return avatars.first;
    return avatars[name.codeUnitAt(0) % avatars.length];
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Share with the community',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedTag, // ignore: deprecated_member_use
                decoration: InputDecoration(
                  labelText: 'Group',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                items: _tags
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedTag = v);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('communityPostField'),
                controller: _controller,
                maxLines: 4,
                autofocus: true,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: "What's on your wellness journey today?",
                  hintStyle: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                  filled: true,
                  fillColor: AppColors.chipBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  key: const Key('communitySubmitPostButton'),
                  onPressed: _isPosting ? null : _post,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: _isPosting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Post',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _CommunityHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.heroBackground,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Connect with your wellness tribe',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textOnDarkMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Group Card ────────────────────────────────────────────────────────────────

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.emoji,
    required this.name,
    required this.members,
    required this.color,
  });

  final String emoji;
  final String name;
  final String members;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('👥', style: TextStyle(fontSize: 10)),
              const SizedBox(width: 3),
              Text(
                members,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Post Card ─────────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});
  final CommunityPost post;

  static const _tagColors = {
    'Nigerian Wellness': (bg: Color(0xFFFFF3E0), text: Color(0xFFE65100)),
    'Rwanda Wellness': (bg: Color(0xFFE8F5E9), text: Color(0xFF1B5E20)),
    'Fitness & Nutrition': (bg: Color(0xFFE3F2FD), text: Color(0xFF1565C0)),
    'Mindful Eating': (bg: Color(0xFFF3E5F5), text: Color(0xFF6A1B9A)),
    'Active Lifestyle': (bg: Color(0xFFFFF9C4), text: Color(0xFFF57F17)),
  };

  @override
  Widget build(BuildContext context) {
    final tagStyle = _tagColors[post.tag] ??
        (bg: const Color(0xFFF5F5F5), text: AppColors.textSecondary);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.64),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.chipBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(post.avatar,
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _timeAgo(post.createdAt),
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tagStyle.bg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  post.tag,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: tagStyle.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.body,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.6,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              LikeButton(postId: post.id, likes: post.likes),
              const SizedBox(width: 20),
              const _EngagementButton(icon: '🔗', count: null),
            ],
          ),
        ],
      ),
    );
  }

  static String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }
}

// ── Like Button ───────────────────────────────────────────────────────────────

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.postId,
    required this.likes,
  });
  final String postId;
  final int likes;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiking = false;

  Future<void> _onTap() async {
    if (_isLiking) return;
    setState(() => _isLiking = true);
    try {
      await context.read<CommunityPostController>().likePost(widget.postId);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to like post.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLiking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLiking ? null : _onTap,
      child: Row(
        children: [
          Text(
            _isLiking ? '🤍' : '❤️',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(width: 4),
          Text(
            '${widget.likes}',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Engagement Button ─────────────────────────────────────────────────────────

class _EngagementButton extends StatelessWidget {
  const _EngagementButton({required this.icon, required this.count});
  final String icon;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 15)),
        if (count != null) ...[
          const SizedBox(width: 4),
          Text(
            '$count',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

// ── Empty Posts State ─────────────────────────────────────────────────────────

class _EmptyPostsState extends StatelessWidget {
  const _EmptyPostsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Column(
        children: [
          Text('🌍', style: TextStyle(fontSize: 36)),
          SizedBox(height: 12),
          Text(
            'No posts yet',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Be the first to share something with your wellness tribe!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
