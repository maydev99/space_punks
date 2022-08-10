import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:space_punks/actors/player.dart';
import 'package:space_punks/game/game_main.dart';
import 'package:space_punks/mechanics/audio_manager.dart';


// Represents a Teleporter in the game world.
class Teleporter extends SpriteComponent with CollisionCallbacks, HasGameRef<GameMain> {
  Function? onPlayerEnter;

  Teleporter(
      Image image, {
        this.onPlayerEnter,
        Vector2? position,
        Vector2? size,
        Vector2? scale,
        double? angle,
        Anchor? anchor,
        int? priority,
        Vector2? targetPosition,
      }) : super.fromImage(
    image,
    srcPosition: Vector2(64 * 2, 64 * 3),
    srcSize: Vector2.all(62),
    position: position,
    size: size,
    scale: scale,
    angle: angle,
    anchor: anchor, priority: priority,
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
      AudioManager.instance.playTeleportSound();
      gameRef.makeAToast('Teleported');
      onPlayerEnter?.call();

    }
    super.onCollisionStart(intersectionPoints, other);
  }
}