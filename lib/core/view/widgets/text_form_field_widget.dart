// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_localization.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextInputType keyboardType;
  final String? hintText;
  bool obscureText;
  final bool isPassword;
  final VoidCallback? searchOnPressed;
  final TextEditingController controller;
  final String? Function(String?) validator;

  TextFormFieldWidget({
    required this.controller,
    required this.validator,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    this.searchOnPressed,
    super.key,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocalization.isArabic();
    return TextFormField(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
        overflow: TextOverflow.ellipsis,
      ),
      cursorColor: AppColors.primary,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        hintTextDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
          overflow: TextOverflow.ellipsis,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  widget.obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xff454A4F),
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    widget.obscureText = !widget.obscureText;
                  });
                },
              )
            : widget.hintText == 'ابحث عن كتاب'
            ? IconButton(
                icon: Icon(
                  Icons.search,
                  color: const Color(0xff454A4F),
                  size: 32.sp,
                ),
                onPressed: widget.searchOnPressed,
              )
            : null,

        contentPadding: const EdgeInsets.all(15),
        enabledBorder: outlineInputBorder(
          color: AppColors.grey,
          radius: 10.r,
          width: 1.2.r,
        ),
        focusedBorder: outlineInputBorder(
          color: AppColors.primary,
          radius: 10.r,
          width: 1,
        ),
        errorBorder: outlineInputBorder(
          color: Colors.red,
          radius: 10.r,
          width: 1,
        ),
        focusedErrorBorder: outlineInputBorder(
          color: Colors.red,
          radius: 10,
          width: 1,
        ),
      ),
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      validator: widget.validator,
    );
  }

  OutlineInputBorder outlineInputBorder({
    required double radius,
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
