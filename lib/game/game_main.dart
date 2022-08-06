import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:get_storage/get_storage.dart';
import 'package:space_punks/game/player_data.dart';
import 'package:space_punks/level/level.dart';
import 'package:space_punks/mechanics/tap_component.dart';
import 'package:space_punks/overlays/game_over_overlay.dart';
import 'package:space_punks/overlays/hud_overlay.dart';
import 'package:space_punks/overlays/toast_image_overlay.dart';
import 'package:space_punks/overlays/toast_overlay.dart';

class GameMain extends FlameGame with HasCollisionDetection, HasTappableComponents, HasTappablesBridge {
  Level? currentLevel;
  late Image spritesheet;
  late Image punky;
  late Image fireSpriteSheet;
  late Image bob;
  late Image moreTile;
  late TapComponent tapComponent;
  late double screenX;
  late double screenY;
  final playerData = PlayerData();
  late int score;
  late int high;
  final Timer _toastTimer = Timer(1);
  bool isShowingToast = false;
  var box = GetStorage();

  @override
  Future<void>? onLoad() async{

    spritesheet = await images.load('spritesheet.png');
    fireSpriteSheet = await images.load('lava_1.png');
    punky = await images.load('punky_64.png');
    bob = await images.load('bob_walk_2.png');
    moreTile = await images.load('more_tile.png');
    screenX = size.x;
    screenY = size.y;

    camera.viewport = FixedResolutionViewport(Vector2(900,450));
    loadLevel('level1.tmx');

    return super.onLoad();
  }

  @override
  void onMount() {
    var savedHighScore = box.read('high_score') ?? 0;
    playerData.highScore.value = savedHighScore;

    _toastTimer.onTick = () {
      isShowingToast = false;
    };

    super.onMount();
  }

  @override
  void update(double dt) {
    int lives = playerData.health.value;
    score = playerData.score.value;
    high = playerData.highScore.value;
    saveHighScore();

    int bonusLifePointCount = playerData.bonusLifePointCount.value;

    if(lives < 1) {
      pauseEngine();
      saveHighScore();
      playerData.hasBeenNotifiedOfHighScore.value = false;
      overlays.add(GameOverOverlay.id);
    }

    if(bonusLifePointCount >= 100) {
      makeAToast('Bonus Life +1');
      playerData.health.value += 1;
      playerData.bonusLifePointCount.value = 0;
    }

    if (!isShowingToast) {
      overlays.remove(ToastImageOverlay.id);
      overlays.remove(ToastOverlay.id);
    }

    _toastTimer.update(dt);


    super.update(dt);
  }

  void saveHighScore() {
    if (score > high) {
      playerData.highScore.value = score;
    }
  }

  void restartGame() {
    playerData.health.value = 5;
    playerData.key.value = false;
    playerData.score.value = 0;
  }

  void makeAToast(String message) {
    playerData.toast.value = message;
    isShowingToast = true;
    overlays.add(ToastOverlay.id);
    _toastTimer.start();
  }

  void makeImageToast(String message, String image) {
    playerData.toast.value = message;
    playerData.toastImage.value = image;
    isShowingToast = true;
    overlays.add(ToastImageOverlay.id);
    _toastTimer.start();
  }
  void loadLevel(String levelName) {
    currentLevel?.removeFromParent();
    currentLevel = Level(levelName);
    add(currentLevel!);
    tapComponent = TapComponent(size.x, size.y, screenX, screenY);
    add(tapComponent);

  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        resumeEngine();
        /*if (!(overlays.isActive(PauseOverlay.id)) &&
            !(overlays.isActive(PauseOverlay.id))) {
        }*/

        break;
      case AppLifecycleState.paused:


        break;
      case AppLifecycleState.detached:
      //overlays.add(PauseOverlay.id);
      //saveHighScore();
        pauseEngine();
        break;
      case AppLifecycleState.inactive:
      /*if (overlays.isActive(HudOverlay.id)) {
          overlays.remove(HudOverlay.id);
          overlays.add(PauseOverlay.id);
        }*/

        pauseEngine();
        //saveHighScore();

        break;
    }
    super.lifecycleStateChange(state);
  }

}