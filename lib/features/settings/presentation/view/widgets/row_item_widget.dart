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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 28.sp),
            SizedBox(width: 16.w),
            Text(
              widget.title,
              style: TextStyle(
                color: isLightTheme
                    ? AppColors.textPrimary
                    : AppColors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        DropdownButton<String>(
          underline: const SizedBox.shrink(),
          icon: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20.sp,
            color: isLightTheme ? AppColors.textPrimary : AppColors.white,
          ),
          value: effectiveValue,
          items: widget.items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: isLightTheme
                      ? AppColors.textPrimary
                      : AppColors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
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
                      when v == S.of(context).settings_page_title1_value1 =>
                    VoiceModeState.voice1,
                  final v
                      when v == S.of(context).settings_page_title1_value2 =>
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
              } else if (widget.title == S.of(context).settings_page_title2) {
                selectedTheme = value;
                if (value == S.of(context).settings_page_title2_value1) {
                  ThemeCubit.get(context).selectTheme(ThemeModeState.system);
                } else if (value == S.of(context).settings_page_title2_value2) {
                  ThemeCubit.get(context).selectTheme(ThemeModeState.light);
                } else if (value == S.of(context).settings_page_title2_value3) {
                  ThemeCubit.get(context).selectTheme(ThemeModeState.dark);
                }
              } else if (widget.title == S.of(context).settings_page_title3) {
                selectedLanguage = value;
                if (value == S.of(context).settings_page_title3_value1) {
                  LanguageCubit.get(context).selectLanguage(LanguageModeState.arabic);
                } else if (value == S.of(context).settings_page_title3_value2) {
                  LanguageCubit.get(context).selectLanguage(LanguageModeState.english);
                }
              }
              if (mounted) setState(() {});
            }
          },
        ),
      ],
    );
  }
}
