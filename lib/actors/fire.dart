import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:space_punks/actors/player.dart';

import '../game/game_main.dart';

enum FireState{
  fullOn,

}

class Fire extends SpriteAnimationGroupComponent
    with CollisionCallbacks, HasGameRef<GameMain> {

  static final _animationMap = {
    FireState.fullOn: SpriteAnimationData.sequenced(amount: 4, stepTime: 0.1, textureSize: Vector2(64,64))
  };


  Fire(
      Image image, {
        Vector2? srcPosition,
        Vector2? srcSize,
        Vector2? position,
        Vector2? size,
        Vector2? scale,
        double? angle,
        Anchor? anchor,
        int? priority,
      }) : super.fromFrameData(image, _animationMap, position: position, size: size);

  @override
  Future<void>? onLoad() {
    add(CircleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }

  @override
  void onMount() {
    current = FireState.fullOn;
    super.onMount();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      print('Fire');

    }
    super.onCollisionStart(intersectionPoints, other);
  }
}