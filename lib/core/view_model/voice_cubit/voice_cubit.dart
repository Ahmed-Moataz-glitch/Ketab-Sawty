import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ketab_sawty/core/utils/shared_preferences.dart';

part 'voice_state.dart';

enum VoiceModeState { voice1, voice2, voice3 }

class VoiceCubit extends Cubit<VoiceState> {
  VoiceCubit() : super(VoiceInitial()) {
    loadVoice();
  }

  VoiceModeState currentvoice = VoiceModeState.voice1;

  static VoiceCubit get(BuildContext context) =>
      BlocProvider.of<VoiceCubit>(context);

  Future<void> selectVoice(VoiceModeState voice) async {
    currentvoice = voice;
    await FlutterSharedPreferences.instance.saveVoice(voice.toString());
    emit(VoiceChanged());
  }

  String getVoice() {
    switch (currentvoice) {
      case VoiceModeState.voice1:
        return 'ar-xa-x-arz-local';
      case VoiceModeState.voice2:
        return 'ar-xa-x-ard-local';
      case VoiceModeState.voice3:
        return 'ar-xa-x-arc-network';
    }
  }

  Future<void> loadVoice() async {
    final voice = await FlutterSharedPreferences.instance.getVoice();
    currentvoice = voice;
    emit(VoiceChanged());
  }
}
