import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/features/favorites/presentation/view/pages/favorites_page.dart';
import 'package:ketab_sawty/features/home/presentation/view/pages/home_page.dart';
import 'package:ketab_sawty/features/my_library/presentation/view/pages/my_library_page.dart';
import 'package:ketab_sawty/features/settings/presentation/view/pages/settings_page.dart';

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
  late final PageController pageController;
  int activeIndex = 0;
  List<Widget> pages = [
    const HomePage(),
    const MyLibraryPage(),
    const FavoritesPage(),
    const SettingsPage(),
  ];
  List<TabItem> tabs = [
    TabItem(label: 'الرئيسية', icon: Icons.home),
    TabItem(label: 'مكتبتى', icon: Icons.library_books),
    TabItem(label: 'المفضلة', icon: Icons.favorite),
    TabItem(label: 'الإعدادات', icon: Icons.settings),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: activeIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: AppColors.white,
        borderColor: AppColors.primary,
        tabBuilder: (index, isActive) {
          final color = isActive ? AppColors.primary : AppColors.grey;
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
