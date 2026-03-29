import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:carolie_tracking_app/src/widgets/app_shell.dart';
import 'package:flutter/material.dart';

//Data

const _groups = [
  (
    emoji: '🇳🇬',
    name: 'Nigerian Wellness',
    members: '2.4k',
    color: Color(0xFFFFF3E0),
  ),
  (
    emoji: '🥗',
    name: 'Fitness & Nutrition',
    members: '1.8k',
    color: Color(0xFFE8F5E9),
  ),
  (
    emoji: '🧘',
    name: 'Mindful Eating',
    members: '3.1k',
    color: Color(0xFFE3F2FD),
  ),
  (
    emoji: '🏃',
    name: 'Active Lifestyle',
    members: '980',
    color: Color(0xFFF3E5F5),
  ),
];

const _posts = [
  (
    avatar: '🧑🏾',
    username: 'Amara O.',
    time: '2 hours ago',
    tag: 'Nigerian Wellness',
    tagColor: Color(0xFFFFF3E0),
    tagTextColor: Color(0xFFE65100),
    body:
        'Just made a healthy version of Egusi soup with less palm oil 🥬 Feeling great about hitting my protein goals today! Who else is on this journey? 💪',
    likes: 48,
    comments: 12,
  ),
  (
    avatar: '👩🏽',
    username: 'Chisom B.',
    time: '5 hours ago',
    tag: 'Fitness & Nutrition',
    tagColor: Color(0xFFE8F5E9),
    tagTextColor: Color(0xFF2E7D32),
    body:
        'Swapped white rice for ofada rice this week and my energy levels are so much better 🌾 Small changes, big results! Anyone tried fonio yet?',
    likes: 73,
    comments: 21,
  ),
  (
    avatar: '🧔🏿',
    username: 'Emeka T.',
    time: 'Yesterday',
    tag: 'Active Lifestyle',
    tagColor: Color(0xFFF3E5F5),
    tagTextColor: Color(0xFF6A1B9A),
    body:
        'Morning run done ✅ Fueled by akara and zobo 😄 Tracking my meals on this app has been a game changer. Highly recommend logging everything!',
    likes: 31,
    comments: 8,
  ),
];

//Screen

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
    return AppViewport(
      bottomNavigationBar: AppBottomNavigation(
        currentScreen: AppScreen.tribe,
        onTabSelected: onTabSelected,
      ),
      child: Stack(
        children: [
          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CommunityHeader(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 24),

                    // YOUR GROUPS label
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

                    // Horizontal groups carousel
                    SizedBox(
                      height: 130,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _groups.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
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

                    // COMMUNITY FEED label
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

                    // Vertical list of post cards
                    ..._posts.map(
                      (p) => Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: _PostCard(
                          avatar: p.avatar,
                          username: p.username,
                          time: p.time,
                          tag: p.tag,
                          tagColor: p.tagColor,
                          tagTextColor: p.tagTextColor,
                          body: p.body,
                          likes: p.likes,
                          comments: p.comments,
                        ),
                      ),
                    ),

                    // Extra space so FAB doesn't cover the last post
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),

          // ── Floating + button
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
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

//New Post Bottom Sheet

class _NewPostSheet extends StatefulWidget {
  const _NewPostSheet();

  @override
  State<_NewPostSheet> createState() => _NewPostSheetState();
}

class _NewPostSheetState extends State<_NewPostSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
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
          const SizedBox(height: 16),

          // Text input
          TextField(
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

          // Post button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text(
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
    );
  }
}

//Header

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

//Group Card
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

//Post Card

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.avatar,
    required this.username,
    required this.time,
    required this.tag,
    required this.tagColor,
    required this.tagTextColor,
    required this.body,
    required this.likes,
    required this.comments,
  });

  final String avatar;
  final String username;
  final String time;
  final String tag;
  final Color tagColor;
  final Color tagTextColor;
  final String body;
  final int likes;
  final int comments;

  @override
  Widget build(BuildContext context) {
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
          // Header: avatar + name + time + tag
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
                  child: Text(avatar, style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: tagTextColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Body text
          Text(
            body,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.6,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          // Engagement row
          Row(
            children: [
              _EngagementButton(icon: '❤️', count: likes),
              const SizedBox(width: 20),
              _EngagementButton(icon: '💬', count: comments),
              const SizedBox(width: 20),
              const _EngagementButton(icon: '🔗', count: null),
            ],
          ),
        ],
      ),
    );
  }
}

//Engagement Button
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
