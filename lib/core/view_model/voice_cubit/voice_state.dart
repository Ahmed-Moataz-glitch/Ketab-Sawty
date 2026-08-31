part of 'voice_cubit.dart';

sealed class VoiceState {}

final class VoiceInitial extends VoiceState {}

final class VoiceChanged extends VoiceState {
  VoiceChanged();
}
