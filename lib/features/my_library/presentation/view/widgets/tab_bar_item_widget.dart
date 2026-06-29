// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:ketab_sawty/core/utils/app_colors.dart';

// class TabBarItemWidget extends StatefulWidget {
//   final String title;
//   final bool isAllSelected;
//   final bool isCompletedSelected;
//   final bool isNotCompletedSelected;
//   const TabBarItemWidget({
//     super.key,
//     required this.title,
//     this.isAllSelected = false,
//     this.isCompletedSelected = false,
//     this.isNotCompletedSelected = false,
//   });

//   @override
//   State<TabBarItemWidget> createState() => _TabBarItemWidgetState();
// }

// class _TabBarItemWidgetState extends State<TabBarItemWidget> {
//   bool isAllSelected = false;
//   bool isCompletedSelected = false;
//   bool isNotCompletedSelected = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           if (widget.isAllSelected) {
//             isAllSelected = true;
//             isCompletedSelected = false;
//             isNotCompletedSelected = false;
//           } else if (widget.isCompletedSelected) {
//             isAllSelected = false;
//             isCompletedSelected = true;
//             isNotCompletedSelected = false;
//           } else {
//             isNotCompletedSelected = true;
//             isCompletedSelected = false;
//             isAllSelected = false;
//           }
//         });
//       },
//       child: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: AppColors.border,
//           borderRadius: BorderRadius.circular(24.r),
//           border:
//               (isAllSelected &&
//                       !isCompletedSelected & !isNotCompletedSelected) ||
//                   (!isAllSelected &&
//                       isCompletedSelected & !isNotCompletedSelected) ||
//                   (!isAllSelected &&
//                       !isCompletedSelected & isNotCompletedSelected)
//               ? Border.all(color: AppColors.primary, width: 2.r)
//               : null,
//         ),
//         child: Text(
//           widget.title,
//           style: TextStyle(
//             fontSize: 16.sp,
//             color: AppColors.textPrimary,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
