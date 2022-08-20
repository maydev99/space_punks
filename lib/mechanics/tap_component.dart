import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:space_punks/actors/player.dart';

import '../game/game_main.dart';


class TapComponent extends PositionComponent
    with TapCallbacks, HasGameRef<GameMain> {
  late double tapX;
  late double tapY;
  Player? _player;

  TapComponent(double width, double height, double screenX, double screenY)
      : super(size: Vector2(screenX, screenY));

  void connectPLayer(Player player) {
    _player = player;
  }

  @override
  Future<void>? onLoad() {
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {

    tapX = event.canvasPosition.x;
    tapY = event.canvasPosition.y;

    double centerScreenXStart = width / 3;

    if (tapX < centerScreenXStart) {
      _player?.hAxisInput = -2;

    }

    if (tapX >= centerScreenXStart && tapX < width - centerScreenXStart) {
      _player?.hAxisInput = 2;
    }

    if (tapX > centerScreenXStart * 2) {
      _player?.jump = true;
    }

    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    tapX = event.canvasPosition.x;
    tapY = event.canvasPosition.y;
    double centerScreenXStart = width / 3;

    if (tapX < centerScreenXStart) {
      _player?.hAxisInput = -0;

    }

    if (tapX >= centerScreenXStart && tapX < width - centerScreenXStart) {
      _player?.hAxisInput = 0;
    }

    if (tapX > centerScreenXStart * 2) {
      _player?.jump = true;
    }
    super.onTapUp(event);
  }
}