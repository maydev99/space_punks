import 'dart:ui';

import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:space_punks/level/level.dart';
import 'package:space_punks/mechanics/tap_component.dart';

class GameMain extends FlameGame with HasCollisionDetection, HasTappableComponents, HasTappablesBridge {
  Level? currentLevel;
  late Image spritesheet;
  late Image punky;
  late TapComponent tapComponent;
  late double screenX;
  late double screenY;

  @override
  Future<void>? onLoad() async{
    spritesheet = await images.load('spritesheet.png');
    punky = await images.load('punky_64.png');
    screenX = size.x;
    screenY = size.y;

    camera.viewport = FixedResolutionViewport(Vector2(900,450));
    loadLevel('rocket_level.tmx');

    return super.onLoad();
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