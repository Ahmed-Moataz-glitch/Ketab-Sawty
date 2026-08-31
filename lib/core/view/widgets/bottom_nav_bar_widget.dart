import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/get_it.dart';
import 'package:ketab_sawty/features/favorites/presentation/view/pages/favorites_page.dart';
import 'package:ketab_sawty/features/home/presentation/view/pages/home_page.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/features/my_library/presentation/view/pages/my_library_page.dart';
import 'package:ketab_sawty/features/settings/presentation/view/pages/settings_page.dart';
import 'package:ketab_sawty/generated/l10n.dart';

class BottomNavBarWidget extends StatefulWidget {
  const BottomNavBarWidget({super.key});

  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class TabItem {
  final IconData icon;
  final String label;

  TabItem({required this.label, required this.icon});
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  late HomeCubit homeCubit;
  late final PageController pageController;
  int activeIndex = 0;
  late List<Widget> pages;
  late List<TabItem> tabs;

  @override
  void initState() {
    super.initState();
    homeCubit = getIt<HomeCubit>();
    pageController = PageController(initialPage: activeIndex);
    pages = [
      HomePage(homeCubit: homeCubit),
      MyLibraryPage(homeCubit: homeCubit),
      FavoritesPage(homeCubit: homeCubit),
      const SettingsPage(),
    ];
  }

  @override
  void dispose() {
    homeCubit.close();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    tabs = [
      TabItem(label: S.of(context).bottom_nav_bar_home, icon: Icons.home),
      TabItem(
        label: S.of(context).bottom_nav_bar_my_library,
        icon: Icons.library_books,
      ),
      TabItem(
        label: S.of(context).bottom_nav_bar_favorites,
        icon: Icons.favorite,
      ),
      TabItem(
        label: S.of(context).bottom_nav_bar_settings,
        icon: Icons.settings,
      ),
    ];
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => setState(() => activeIndex = index),
        physics:
            const NeverScrollableScrollPhysics(), // Disable swipe navigation
        children: pages,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: tabs.length,
        activeIndex: activeIndex,
        onTap: _onTabTapped,
        gapLocation: GapLocation.none,
        // activeColor: AppColors.primary,
        // inactiveColor: AppColors.grey,
        elevation: 10,
        backgroundColor: isLightTheme ? AppColors.white : AppColors.dark,
        borderColor: isLightTheme ? AppColors.primary : AppColors.grey,
        tabBuilder: (index, isActive) {
          final color = isActive
              ? isLightTheme
                    ? AppColors.primary
                    : AppColors.primaryLight
              : AppColors.textSecondary;
          return SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(tabs[index].icon, color: color, size: 24),
                const SizedBox(height: 4),
                Text(
                  tabs[index].label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12.sp,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onTabTapped(int index) {
    activeIndex = index;
    // Animated navigation between screens
    pageController.animateToPage(
      activeIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutCirc,
    );
  }
}
