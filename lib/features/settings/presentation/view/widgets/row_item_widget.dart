import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ketab_sawty/core/utils/app_colors.dart';
import 'package:ketab_sawty/core/utils/app_localization.dart';
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
    // final size = MediaQuery.of(context).size;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final isArabic = AppLocalization.isArabic();
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
    return isArabic
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 16.w,
                children: [
                  Icon(widget.icon, size: 28.sp),
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
              const Spacer(),
              DropdownButton(
                underline: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.transparent,
                      width: 1.r,
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20.sp,
                  color: isLightTheme ? AppColors.textPrimary : AppColors.white,
                ),
                value: widget.title == S.of(context).settings_page_title1
                    ? selectedVoice
                    : widget.title == S.of(context).settings_page_title2
                    ? selectedTheme
                    : selectedLanguage,
                items: widget.items.map((item) {
                  return DropdownMenuItem(
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
                    onTap: () {
                      if (widget.title == S.of(context).settings_page_title1) {
                        if (item == S.of(context).settings_page_title1_value1) {
                          VoiceCubit.get(
                            context,
                          ).selectVoice(VoiceModeState.voice1);
                        } else if (item ==
                            S.of(context).settings_page_title1_value2) {
                          VoiceCubit.get(
                            context,
                          ).selectVoice(VoiceModeState.voice2);
                        } else if (item ==
                            S.of(context).settings_page_title1_value3) {
                          VoiceCubit.get(
                            context,
                          ).selectVoice(VoiceModeState.voice3);
                        }
                      } else if (widget.title ==
                          S.of(context).settings_page_title2) {
                        if (item == S.of(context).settings_page_title2_value1) {
                          ThemeCubit.get(
                            context,
                          ).selectTheme(ThemeModeState.system);
                        } else if (item ==
                            S.of(context).settings_page_title2_value2) {
                          ThemeCubit.get(
                            context,
                          ).selectTheme(ThemeModeState.light);
                        } else if (item ==
                            S.of(context).settings_page_title2_value3) {
                          ThemeCubit.get(
                            context,
                          ).selectTheme(ThemeModeState.dark);
                        }
                      } else if (widget.title ==
                          S.of(context).settings_page_title3) {
                        if (item == S.of(context).settings_page_title3_value1) {
                          LanguageCubit.get(
                            context,
                          ).selectLanguage(LanguageModeState.arabic);
                        } else if (item ==
                            S.of(context).settings_page_title3_value2) {
                          LanguageCubit.get(
                            context,
                          ).selectLanguage(LanguageModeState.english);
                        }
                      }
                    },
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

                      // map state -> voiceId
                      selectedVoiceId = switch (voiceState) {
                        VoiceModeState.voice1 => 'ar-xa-x-arz-local',
                        VoiceModeState.voice2 => 'ar-xa-x-ard-local',
                        VoiceModeState.voice3 => 'ar-xa-x-arc-network',
                      };
                      debugPrint('Selected Voice ID: $selectedVoiceId');
                      await homeCubit.speakArabicTestWithNewVoice(
                        text: 'هذا مقطع تجريبي',
                        voice: selectedVoiceId,
                      );
                    } else if (widget.title ==
                        S.of(context).settings_page_title2) {
                      selectedTheme = value;
                    } else if (widget.title ==
                        S.of(context).settings_page_title3) {
                      selectedLanguage = value;
                    }
                    setState(() {});
                  }
                },
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 16.w,
                children: [
                  Icon(widget.icon, size: 28.sp),
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
              const Spacer(),
              DropdownButton(
                underline: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.transparent,
                      width: 1.r,
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20.sp,
                  color: isLightTheme ? AppColors.textPrimary : AppColors.white,
                ),
                value: widget.title == S.of(context).settings_page_title1
                    ? selectedVoice
                    : widget.title == S.of(context).settings_page_title2
                    ? selectedTheme
                    : selectedLanguage,
                items: widget.items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      if (widget.title == S.of(context).settings_page_title1) {
                        if (item == S.of(context).settings_page_title1_value1) {
                          VoiceCubit.get(
                            context,
                          ).selectVoice(VoiceModeState.voice1);
                        } else if (item ==
                            S.of(context).settings_page_title1_value2) {
                          VoiceCubit.get(
                            context,
                          ).selectVoice(VoiceModeState.voice2);
                        } else if (item ==
                            S.of(context).settings_page_title1_value3) {
                          VoiceCubit.get(
                            context,
                          ).selectVoice(VoiceModeState.voice3);
                        }
                      } else if (widget.title ==
                          S.of(context).settings_page_title2) {
                        if (item == S.of(context).settings_page_title2_value1) {
                          ThemeCubit.get(
                            context,
                          ).selectTheme(ThemeModeState.system);
                        } else if (item ==
                            S.of(context).settings_page_title2_value2) {
                          ThemeCubit.get(
                            context,
                          ).selectTheme(ThemeModeState.light);
                        } else if (item ==
                            S.of(context).settings_page_title2_value3) {
                          ThemeCubit.get(
                            context,
                          ).selectTheme(ThemeModeState.dark);
                        }
                      } else if (widget.title ==
                          S.of(context).settings_page_title3) {
                        if (item == S.of(context).settings_page_title3_value1) {
                          LanguageCubit.get(
                            context,
                          ).selectLanguage(LanguageModeState.arabic);
                        } else if (item ==
                            S.of(context).settings_page_title3_value2) {
                          LanguageCubit.get(
                            context,
                          ).selectLanguage(LanguageModeState.english);
                        }
                      }
                    },
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

                      // map state -> voiceId
                      selectedVoiceId = switch (voiceState) {
                        VoiceModeState.voice1 => 'ar-xa-x-arz-local',
                        VoiceModeState.voice2 => 'ar-xa-x-ard-local',
                        VoiceModeState.voice3 => 'ar-xa-x-arc-network',
                      };
                      debugPrint('Selected Voice ID: $selectedVoiceId');
                      await homeCubit.speakArabicTestWithNewVoice(
                        text: 'هذا مقطع تجريبي',
                        voice: selectedVoiceId,
                      );
                    } else if (widget.title ==
                        S.of(context).settings_page_title2) {
                      selectedTheme = value;
                    } else if (widget.title ==
                        S.of(context).settings_page_title3) {
                      selectedLanguage = value;
                    }
                    setState(() {});
                  }
                },
              ),
            ],
          );
  }
}
