import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:space_punks/actors/platform.dart';
import 'package:space_punks/actors/player.dart';
import 'package:space_punks/game/game_main.dart';

class MovingPlatform extends SpriteComponent
    with CollisionCallbacks, HasGameRef<GameMain>
    implements Platform {
  static final Vector2 _up = Vector2(0, -1);

  MovingPlatform(
    Image image, {
    Vector2? srcPosition,
    Vector2? srcSize,
    Vector2? targetPosition,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super.fromImage(image,
            srcPosition: Vector2(64, 64 * 2),
            srcSize: Vector2(62, 62),
            position: position,
            size: size,
            scale: scale,
            angle: angle,
            anchor: anchor,
            priority: priority) {
    if (targetPosition != null && position != null) {
      final effect = SequenceEffect(
        [
          MoveToEffect(targetPosition, EffectController(speed: 100),
              onComplete: () {
            //flipHorizontallyAroundCenter();
          }),
          MoveToEffect(position + Vector2(32, 0), EffectController(speed: 100),
              onComplete: () {
            //flipHorizontallyAroundCenter();
          })
        ],
        infinite: true,
      );

      add(effect);
    }
  }

  @override
  Future<void>? onLoad() {
    add(CircleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      //  final playerDir = (other.absoluteCenter - absoluteCenter).normalized();

      // if (playerDir.dot(_up) > 0.85) {
      /* add(
          OpacityEffect.fadeOut(
            LinearEffectController(0.2),
            onComplete: () => removeFromParent(),
          ),
        );
      //  gameRef.playerData.health.value += 1;
      //  other.jump = true;
      } else {
        other.hit();
        if (gameRef.playerData.health.value > 0) {
          gameRef.playerData.health.value -= 1;
        }
      }*/

    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
