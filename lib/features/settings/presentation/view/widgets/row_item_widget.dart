import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/get_it.dart';
import 'package:ketab_sawty/core/view_model/language_cubit/language_cubit.dart';
import 'package:ketab_sawty/core/view_model/theme_cubit/theme_cubit.dart';
import 'package:ketab_sawty/core/view_model/voice_cubit/voice_cubit.dart';
import 'package:ketab_sawty/features/home/presentation/view_model/home_cubit.dart';
import 'package:ketab_sawty/generated/l10n.dart';

class RowItemWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<String> items;
  const RowItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  State<RowItemWidget> createState() => _RowItemWidgetState();
}

class _RowItemWidgetState extends State<RowItemWidget> {
  late final HomeCubit homeCubit;
  late String selectedVoice;
  late String selectedTheme;
  late String selectedLanguage;
  String selectedVoiceId = 'ar-xa-x-arz-local';

  @override
  void initState() {
    super.initState();
    homeCubit = getIt<HomeCubit>();
  }

  @override
  void dispose() {
    homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    selectedVoice = switch (VoiceCubit.get(context).currentvoice) {
      VoiceModeState.voice1 => S.of(context).settings_page_title1_value1,
      VoiceModeState.voice2 => S.of(context).settings_page_title1_value2,
      VoiceModeState.voice3 => S.of(context).settings_page_title1_value3,
    };
    selectedTheme = switch (ThemeCubit.get(context).currentThemeMode) {
      ThemeModeState.system => S.of(context).settings_page_title2_value1,
      ThemeModeState.light => S.of(context).settings_page_title2_value2,
      ThemeModeState.dark => S.of(context).settings_page_title2_value3,
    };
    selectedLanguage = switch (LanguageCubit.get(context).currentLanguage) {
      LanguageModeState.arabic => S.of(context).settings_page_title3_value1,
      LanguageModeState.english => S.of(context).settings_page_title3_value2,
    };

    final currentValue = widget.title == S.of(context).settings_page_title1
        ? selectedVoice
        : widget.title == S.of(context).settings_page_title2
        ? selectedTheme
        : selectedLanguage;

    final effectiveValue = widget.items.contains(currentValue)
        ? currentValue
        : (widget.items.isNotEmpty ? widget.items.first : null);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: isLightTheme
                        ? AppColors.primary.withAlpha(20)
                        : AppColors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 22.sp,
                    color: isLightTheme
                        ? AppColors.primary
                        : AppColors.primaryLight,
                  ),
                ),
                SizedBox(width: 14.w),
                Flexible(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: isLightTheme
                          ? AppColors.textPrimary
                          : AppColors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isDense: true,
                isExpanded: true,
                dropdownColor: isLightTheme ? AppColors.white : AppColors.dark,
                borderRadius: BorderRadius.circular(12.r),
                icon: Padding(
                  padding: EdgeInsetsDirectional.only(start: 8.w, end: 2.w),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.sp,
                    color: AppColors.grey,
                  ),
                ),
                value: effectiveValue,
                selectedItemBuilder: (context) {
                  return widget.items.map((item) {
                    return Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        item,
                        style: TextStyle(
                          color: isLightTheme
                              ? AppColors.primary
                              : AppColors.primaryLight,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList();
                },
                items: widget.items.map((item) {
                  final isSelected = item == effectiveValue;
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        color: isSelected
                            ? (isLightTheme
                                  ? AppColors.primary
                                  : AppColors.primaryLight)
                            : (isLightTheme
                                  ? AppColors.textPrimary
                                  : AppColors.white),
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) async {
                  if (value != null) {
                    if (widget.title == S.of(context).settings_page_title1) {
                      selectedVoice = value;
                      final voiceState = switch (value) {
                        final v
                            when v ==
                                S.of(context).settings_page_title1_value1 =>
                          VoiceModeState.voice1,
                        final v
                            when v ==
                                S.of(context).settings_page_title1_value2 =>
                          VoiceModeState.voice2,
                        _ => VoiceModeState.voice3,
                      };

                      await VoiceCubit.get(context).selectVoice(voiceState);

                      selectedVoiceId = VoiceCubit.voiceIdFromMode(voiceState);
                      homeCubit.updateVoice(selectedVoiceId);
                      debugPrint('Selected Voice ID: $selectedVoiceId');
                      try {
                        await homeCubit.speakArabicTestWithNewVoice(
                          text: 'هذا مقطع تجريبي لصوت القارئ',
                          voice: selectedVoiceId,
                        );
                      } catch (e) {
                        debugPrint('Test voice error: $e');
                      }
                    } else if (widget.title ==
                        S.of(context).settings_page_title2) {
                      selectedTheme = value;
                      if (value == S.of(context).settings_page_title2_value1) {
                        ThemeCubit.get(
                          context,
                        ).selectTheme(ThemeModeState.system);
                      } else if (value ==
                          S.of(context).settings_page_title2_value2) {
                        ThemeCubit.get(
                          context,
                        ).selectTheme(ThemeModeState.light);
                      } else if (value ==
                          S.of(context).settings_page_title2_value3) {
                        ThemeCubit.get(
                          context,
                        ).selectTheme(ThemeModeState.dark);
                      }
                    } else if (widget.title ==
                        S.of(context).settings_page_title3) {
                      selectedLanguage = value;
                      if (value == S.of(context).settings_page_title3_value1) {
                        LanguageCubit.get(
                          context,
                        ).selectLanguage(LanguageModeState.arabic);
                      } else if (value ==
                          S.of(context).settings_page_title3_value2) {
                        LanguageCubit.get(
                          context,
                        ).selectLanguage(LanguageModeState.english);
                      }
                    }
                    if (mounted) setState(() {});
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
