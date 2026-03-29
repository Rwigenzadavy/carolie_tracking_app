import 'package:carolie_tracking_app/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppScreen { home, logMeal, learn }

class AppViewport extends StatelessWidget {
  const AppViewport({
    super.key,
    required this.child,
    required this.bottomNavigationBar,
  });

  final Widget child;
  final Widget bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            children: [
              Expanded(child: SafeArea(bottom: false, child: child)),
              SafeArea(top: false, child: bottomNavigationBar),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.currentScreen,
    required this.onTabSelected,
  });

  final AppScreen currentScreen;
  final ValueChanged<AppScreen> onTabSelected;

  static const _homeActive = 'assets/figma/home/nav_home';
  static const _homeInactive = 'assets/figma/log/nav_home';
  static const _logActive = 'assets/figma/log/nav_log';
  static const _logInactive = 'assets/figma/home/nav_log';
  static const _learnIcon = 'assets/figma/home/nav_learn';
  static const _tribeIcon = 'assets/figma/home/nav_tribe';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider, width: 0.64)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(39, 13.6, 39, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BottomNavItem(
              key: const Key('navHomeTab'),
              label: 'Home',
              assetPath: currentScreen == AppScreen.home
                  ? _homeActive
                  : _homeInactive,
              isSelected: currentScreen == AppScreen.home,
              onTap: () => onTabSelected(AppScreen.home),
            ),
            _BottomNavItem(
              key: const Key('navLogTab'),
              label: 'Log',
              assetPath: currentScreen == AppScreen.logMeal
                  ? _logActive
                  : _logInactive,
              isSelected: currentScreen == AppScreen.logMeal,
              onTap: () => onTabSelected(AppScreen.logMeal),
            ),
            _BottomNavItem(
              label: 'Learn',
              assetPath: _learnIcon,
              isSelected: currentScreen == AppScreen.learn,
              applyColorFilter: true,
              onTap: () => onTabSelected(AppScreen.learn),
            ),
            _BottomNavItem(
              label: 'Tribe',
              assetPath: _tribeIcon,
              isSelected: false,
              applyColorFilter: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    super.key,
    required this.label,
    required this.assetPath,
    required this.isSelected,
    this.onTap,
    this.applyColorFilter = false,
  });

  final String label;
  final String assetPath;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool applyColorFilter;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              assetPath,
              width: 24,
              height: 24,
              colorFilter: applyColorFilter && isSelected
                  ? const ColorFilter.mode(AppColors.accent, BlendMode.srcIn)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1.5,
                color: isSelected ? AppColors.accent : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
