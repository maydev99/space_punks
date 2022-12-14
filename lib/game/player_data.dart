import 'package:flutter/material.dart';

class PlayerData {
  final score = ValueNotifier<int>(0);
  final health = ValueNotifier<int>(5);
  final key = ValueNotifier<bool>(false);
  final bonusLifePointCount = ValueNotifier<int>(0);
  final toast = ValueNotifier<String>('');
  final toastImage = ValueNotifier<String>('');
  final highScore = ValueNotifier<int>(0);
  final hasBeenNotifiedOfHighScore = ValueNotifier<bool>(false);
  final hasSpawnedHiddenStars = ValueNotifier<bool>(false);
  final injuryLevel = ValueNotifier<int>(0);
  final storyImage = ValueNotifier<String>('assets/images/control_image_half2.png');
  final storyText = ValueNotifier<String>('The Text Goes Here');
}