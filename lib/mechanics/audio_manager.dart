import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  AudioManager._internal();

  late AudioPool popSound;
  late AudioPool squishSound;
  late AudioPool teleportSound;
  late AudioPool dingSound;
  late AudioPool bonusSound;
  late AudioPool ohSound;
  late AudioPool unlockSound;
  late AudioPool lockedSound;


  static final AudioManager _instance = AudioManager._internal();

  static AudioManager get instance => _instance;

  Future<void> init(List<String> files) async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(files);
    popSound = await FlameAudio.createPool('sfx/pop.mp3', maxPlayers: 6);
    squishSound = await FlameAudio.createPool('sfx/squish2.mp3', maxPlayers: 2);
    teleportSound = await FlameAudio.createPool('sfx/teleport3.mp3', maxPlayers: 2);
    dingSound = await FlameAudio.createPool('sfx/ding.mp3', maxPlayers: 2);
    bonusSound = await FlameAudio.createPool('sfx/bonus.mp3', maxPlayers: 1);
    ohSound = await FlameAudio.createPool('sfx/oh.mp3', maxPlayers: 3);
    unlockSound = await FlameAudio.createPool('sfx/unlock.mp3', maxPlayers: 1);
    lockedSound = await FlameAudio.createPool('sfx/locked.mp3', maxPlayers: 1);
  }

  void playPopSound() {
    popSound.start(volume: 1.0);
  }

  void playSquishSound() {
    squishSound.start(volume: 0.5);
  }

  void playDingSound() {
    dingSound.start(volume: 1.0);
  }

  void playTeleportSound() {
    teleportSound.start(volume: 1.0);
  }

  void playBonusSound() {
    bonusSound.start(volume: 1.0);
  }

  void playOhSound() {
    ohSound.start(volume: 1.0);
  }

  void playUnlockSound() {
    unlockSound.start(volume: 1.0);
  }

  void playLockedSound() {
    lockedSound.start(volume: 1.0);
  }
}
