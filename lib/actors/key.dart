
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:space_punks/actors/player.dart';

import '../game/game_main.dart';



// Represents a Key in the game world.
class Key extends SpriteComponent with CollisionCallbacks, HasGameRef<GameMain>{
  Function? onPlayerEnter;

  Key(
      Image image, {
        this.onPlayerEnter,
        Vector2? position,
        Vector2? size,
        Vector2? scale,
        double? angle,
        Anchor? anchor,
        int? priority,
      }) : super.fromImage(
    image,
    srcPosition: Vector2(64, 64),
    srcSize: Vector2.all(62),
    position: position,
    size: size,
    scale: scale,
    angle: angle,
    anchor: anchor,
    priority: priority,
  );

  @override
  Future<void>? onLoad() {
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      add(
        OpacityEffect.fadeOut(LinearEffectController(0.3), onComplete: () {
          gameRef.makeAToast('You found a Key');
          print('Key');
          add(RemoveEffect());
          gameRef.playerData.key.value = true;
        }),
      );

    }
    super.onCollisionStart(intersectionPoints, other);
  }
}