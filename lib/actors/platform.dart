
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_punks/actors/player.dart';

class Platform extends PositionComponent with CollisionCallbacks {

  static final Vector2 _bottom = Vector2(0, 1);
  Platform({
    required Vector2? position,
    required Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    Iterable<Component>? children,
    int? priority,
  }) : super(
      position: position,
      size: size,
      scale: scale,
      angle: angle,
      anchor: anchor,
      priority: priority
  );

  @override
  Future<void>? onLoad() {
    //debugMode = true;
    priority = 1;
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is Player) {
      final playerDir = (other.absoluteCenter - absoluteCenter).normalized();

      if (playerDir.dot(_bottom) > 0.85) {
        print('Hit Bottom');
        //other.velocity.y = 100;
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}