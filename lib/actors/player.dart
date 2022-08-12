import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';

import 'package:flame/input.dart';
import 'package:flutter/services.dart';

import 'package:space_punks/actors/moving_platform.dart';
import 'package:space_punks/game/game_main.dart';

import 'package:space_punks/actors/platform.dart';


enum PlayerState {
  run,
  stand,
  jump,
  idle,
}


class Player extends SpriteAnimationGroupComponent
    with CollisionCallbacks, KeyboardHandler, HasGameRef<GameMain> {
  int _hAxisInput = 0;
  bool _jumpInput = false;
  bool _isOnGround = false;
  final Vector2 velocity = Vector2.zero();
  final double _moveSpeed = 100;
  final double _gravity = 30;
  final double _jumpSpeed = 900;
  final Vector2 _up = Vector2(0, -1);
  late Vector2 _minClamp;
  late Vector2 _maxClamp;
  late Vector2 _myPosition;
  late Vector2 _mySize;
  late String _levelName;
  final Timer _idleTimer = Timer(2);
  bool isIdle = false;
  int injuryCount = 0;

  static final Vector2 _down = Vector2(0, 1);

  static final _animationMap = {
    PlayerState.run: SpriteAnimationData.sequenced(
        amount: 4, stepTime: 0.1, textureSize: Vector2(64, 64)),
    PlayerState.stand: SpriteAnimationData.sequenced(amount: 2,
        stepTime: 1,
        texturePosition: Vector2((4) * 64, 0),
        textureSize: Vector2(64, 64)),
    PlayerState.jump: SpriteAnimationData.sequenced(amount: 2,
        stepTime: 0.2,
        texturePosition: Vector2((10) * 64, 0),
        textureSize: Vector2(64, 64)),
    // PlayerState.idle: SpriteAnimationData.sequenced(amount: 2, stepTime: 0.8, texturePosition: Vector2((4) * 64, 0), textureSize: Vector2(64,64)),
    // PlayerState.smug: SpriteAnimationData.sequenced(amount: 4, stepTime: 0.5 , texturePosition: Vector2((6) * 64, 0), textureSize: Vector2(64,64), loop: false)
  };


  Player(Image image, {
    required Rect levelBounds,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super.fromFrameData(image, _animationMap) {
    // Since anchor point for player is at the center,
    // min and max clamp limits will have to be adjusted by
    // half-size of player.

    _myPosition = position!;
    _mySize = size!;

    final halfSize = size / 2;
    _minClamp = levelBounds.topLeft.toVector2() + halfSize;
    _maxClamp = levelBounds.bottomRight.toVector2() - halfSize;
  }

  @override
  Future<void>? onLoad() {
    _levelName = gameRef.currentLevel!.levelName;
    //debugMode = true;
    position = _myPosition;
    anchor = Anchor.center;
    size = _mySize;
    priority = 3;
    add(CircleHitbox());
    return super.onLoad();
  }

  @override
  void onMount() {
    gameRef.tapComponent.connectPLayer(this);
    current = PlayerState.stand;

    _idleTimer.onTick = () {
      print('Idle');
      isIdle = true;
    };
    super.onMount();
  }

  @override
  void update(double dt) {
    velocity.x = _hAxisInput * _moveSpeed;
    velocity.y += _gravity;

    // print(_velocity.y);
    if (velocity.x != 0) {
      current = PlayerState.run;
    } else {
      current = PlayerState.stand;
    }


    if (velocity.y < _gravity) {
      _isOnGround = false;
      current = PlayerState.jump;
    }

    //Keeps pLayer from sinking into floor on spawn
    //Map Y = 1280  1.5 * Player height (96px)
    if (_levelName != 'rocket_level.tmx') {
      if (position.y > 1184) {
        position.y = 1184;
      }
    }

    if (_jumpInput) {
      current = PlayerState.jump;
      if (_isOnGround) {
        velocity.y = -_jumpSpeed;
        _isOnGround = false;
        current = PlayerState.run;
      } else {

      }

      _jumpInput = false;
    }


    //Terminal Velocity
    velocity.y = velocity.y.clamp(-_jumpSpeed, 400);

    position += velocity * dt;

    position.clamp(_minClamp, _maxClamp);

    if (_hAxisInput < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (_hAxisInput > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }
    super.update(dt);
  }


  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    print('key event');
    _hAxisInput = 0;
    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.keyA) ? -1 : 0;
    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.keyD) ? 1 : 0;
    _jumpInput = keysPressed.contains(LogicalKeyboardKey.space);
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      if (intersectionPoints.length == 2) {
        final mid = (intersectionPoints.elementAt(0) +
            intersectionPoints.elementAt(1)) /
            2;
        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        if (_up.dot(collisionNormal) > 0.9) {
          _isOnGround = true;
        }

        position += collisionNormal.scaled(separationDistance);
      }
    }

    if (other is MovingPlatform) {
      double centerPlatformWidth = other.width / 2;
      position.x = other.position.x + centerPlatformWidth;
    }


    /*if(other is Enemy) {
      final enemyDir = (other.absoluteCenter - absoluteCenter).normalized();
      if(enemyDir.dot(_down) > 0.45) {
        current = PlayerState.smug;
      }
    }*/


    super.onCollision(intersectionPoints, other);
    }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Platform) {
      _isOnGround = false;
      current = PlayerState.jump;
    }
    super.onCollisionEnd(other);
  }

  void hit() {
    add(OpacityEffect.fadeOut(
        EffectController(alternate: true, duration: 0.1, repeatCount: 5)));
  }

  // Setter for horizontal input.
  set hAxisInput(int value) {
    _hAxisInput = value;
  }

  // Setter for jump input.
  set jump(bool value) {
    _jumpInput = value;
  }

  void stopJump() {
    if (_isOnGround) {
      velocity.x = 0;
      velocity.y = 0;
    }
  }

  void teleportToPosition(Vector2 destination) {
    position = Vector2(destination.x, destination.y);
    velocity.x = 0;
  }


}
