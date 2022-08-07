import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:space_punks/actors/platform.dart';
import 'package:space_punks/actors/player.dart';
import 'package:space_punks/game/game_main.dart';


class BonusPlatform extends SpriteComponent
    with CollisionCallbacks, HasGameRef<GameMain>
    implements Platform {
  static final Vector2 _bottom = Vector2(0, 1);
  var isTriggered = false;

  BonusPlatform(
      Image image, {
        Vector2? srcPosition,
        Vector2? srcSize,
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
      priority: priority);

  @override
  Future<void>? onLoad() {
    add(CircleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      final playerDir = (other.absoluteCenter - absoluteCenter).normalized();

      if (playerDir.dot(_bottom) > 0.85) {
        //gameRef.playerData.hasSpawnedHiddenStars.value = true;
        if (!isTriggered) {
          gameRef.playerData.score.value += 50;
          gameRef.playerData.bonusLifePointCount.value += 50;
          isTriggered = true;
          gameRef.makeImageToast('50 Star Bonus', 'star.png');

          add(ColorEffect(const Color.fromARGB(50, 10, 10, 10), const Offset(0, 0.5), EffectController(duration: 0.5)));
        }

        other.velocity.y = 0;
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}