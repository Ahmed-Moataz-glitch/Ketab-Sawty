import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_localization.dart';
import 'package:ketab_sawty/core/utils/get_it.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/features/my_library/presentation/view/widgets/all_tab_view_widget.dart';
import 'package:ketab_sawty/features/my_library/presentation/view/widgets/completed_tab_view_widget.dart';
import 'package:ketab_sawty/features/my_library/presentation/view/widgets/not_completed_tab_view_widget.dart';
import 'package:ketab_sawty/features/my_library/presentation/view_model/my_library_cubit.dart';
import 'package:ketab_sawty/generated/l10n.dart';

class MyLibraryPage extends StatefulWidget {
  final HomeCubit homeCubit;
  const MyLibraryPage({super.key, required this.homeCubit});

  @override
  State<MyLibraryPage> createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibraryPage>
    with TickerProviderStateMixin {
  late final TabController tabController;
  late final MyLibraryCubit myLibraryCubit;
  late List<String> categories;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    myLibraryCubit = getIt<MyLibraryCubit>();
  }

  @override
  void dispose() {
    tabController.dispose();
    myLibraryCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final isArabic = AppLocalization.isArabic();
    categories = [
      S.of(context).my_library_page_tab3,
      S.of(context).my_library_page_tab2,
      S.of(context).my_library_page_tab1,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).my_library_page_app_bar,
          style: TextStyle(
            fontSize: 26.sp,
            color: isLightTheme
                ? AppColors.textPrimary
                : AppColors.white.withAlpha(220),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // TextFormFieldWidget(
            //   hintText: S.of(context).my_library_page_title1,
            //   controller: searchController,
            //   validator: Validator.validateName,
            // ),
            SizedBox(height: 32.h),
            DefaultTabController(
              initialIndex: isArabic ? 2 : 0,
              length: categories.length,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ButtonsTabBar(
                    physics: const NeverScrollableScrollPhysics(),
                    backgroundColor: isLightTheme
                        ? AppColors.primaryLight.withAlpha(50)
                        : AppColors.primaryLight.withAlpha(20),
                    unselectedBackgroundColor: AppColors.border,
                    unselectedLabelStyle: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    labelStyle: TextStyle(
                      color: AppColors.primary,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    radius: 16.r,
                    borderColor: AppColors.primary,
                    borderWidth: 1.5.r,
                    contentPadding: isArabic
                        ? EdgeInsets.symmetric(horizontal: 24.w)
                        : EdgeInsets.symmetric(horizontal: 16.w),
                    buttonMargin: isArabic
                        ? EdgeInsets.symmetric(horizontal: 24.w)
                        : EdgeInsets.symmetric(horizontal: 16.w),
                    contentCenter: true,
                    tabs: [
                      Tab(text: categories[0]),
                      Tab(text: categories[1]),
                      Tab(text: categories[2]),
                    ],
                  ),
                  // TabBar(
                  //   isScrollable: true,
                  //   indicatorColor: Colors.transparent,
                  //   dividerColor: Colors.transparent,
                  //   tabAlignment: TabAlignment.start,
                  //   labelPadding: EdgeInsets.zero,
                  //   onTap: (int index) {
                  //     debugPrint('Selected tab: ${categories[index]}');
                  //   },
                  //   tabs: categories.map((category) {
                  //     category == 'الكل'
                  //         ? isAllSelected
                  //         : category == 'المكتملة'
                  //             ? isCompletedSelected
                  //             : isNotCompletedSelected;
                  //     return TabBarItemWidget(
                  //       title: category,
                  //       isSelected: category == 'الكل'
                  //           ? isAllSelected
                  //           : category == 'المكتملة'
                  //               ? isCompletedSelected
                  //               : isNotCompletedSelected,
                  //     );
                  //   }).toList(),
                  // ),
                  SizedBox(
                    height: size.height * 0.6,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        AllTabViewWidget(
                          myLibraryCubit: myLibraryCubit,
                          homeCubit: widget.homeCubit,
                        ),
                        CompletedTabViewWidget(
                          myLibraryCubit: myLibraryCubit,
                          homeCubit: widget.homeCubit,
                        ),
                        NotCompletedTabViewWidget(
                          myLibraryCubit: myLibraryCubit,
                          homeCubit: widget.homeCubit,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
