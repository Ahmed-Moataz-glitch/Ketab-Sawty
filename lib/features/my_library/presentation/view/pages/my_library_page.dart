import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/view/widgets/text_form_field_widget.dart';
import 'package:ketab_sawty/core/view/widgets/validator.dart';
import 'package:ketab_sawty/features/my_library/presentation/view/widgets/all_tab_view_widget.dart';
import 'package:ketab_sawty/features/my_library/presentation/view/widgets/completed_tab_view_widget.dart';
import 'package:ketab_sawty/features/my_library/presentation/view/widgets/not_completed_tab_view_widget.dart';

class MyLibraryPage extends StatefulWidget {
  const MyLibraryPage({super.key});

  @override
  State<MyLibraryPage> createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibraryPage>
    with TickerProviderStateMixin {
  late final TextEditingController searchController;
  late final TabController tabController;
  bool isAllSelected = false;
  bool isCompletedSelected = false;
  bool isNotCompletedSelected = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مكتبتي',
          style: TextStyle(
            fontSize: 26.sp,
            color: AppColors.textPrimary,
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
            TextFormFieldWidget(
              hintText: 'ابحث عن كتاب',
              controller: searchController,
              validator: Validator.validateName,
            ),
            SizedBox(height: 32.h),
            TabBar(
              indicator: BoxDecoration(
                color: AppColors.transparent,
                borderRadius: BorderRadius.circular(24.r),
              ),
              tabAlignment: TabAlignment.fill,
              tabs: [
                Tab(
                  // text: 'قيد الاستماع',
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isNotCompletedSelected = true;
                        isCompletedSelected = false;
                        isAllSelected = false;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(24.r),
                        border: isNotCompletedSelected
                            ? Border.all(color: AppColors.primary, width: 2.r)
                            : null,
                      ),
                      child: Text(
                        'قيد الاستماع',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  // text: 'مكتمل',
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isNotCompletedSelected = false;
                        isCompletedSelected = true;
                        isAllSelected = false;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(24.r),
                        border: isCompletedSelected
                            ? Border.all(color: AppColors.primary, width: 2.r)
                            : null,
                      ),
                      child: Text(
                        'مكتمل',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  // text: 'الكل',
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isNotCompletedSelected = false;
                        isCompletedSelected = false;
                        isAllSelected = true;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(24.r),
                        border: isAllSelected
                            ? Border.all(color: AppColors.primary, width: 2.r)
                            : null,
                      ),
                      child: Text(
                        'الكل',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              // labelColor: AppColors.primary,
              labelStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              dividerColor: AppColors.transparent,
              // indicatorColor: AppColors.primary,
              // unselectedLabelColor: AppColors.grey,
              controller: tabController,
            ),
            SizedBox(height: size.height * 0.06),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  // MoviesTabViewWidget(homeCubit: homeCubit),
                  // TvSeriesTabViewWidget(homeCubit: homeCubit),
                  NotCompletedTabViewWidget(),
                  CompletedTabViewWidget(),
                  AllTabViewWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
