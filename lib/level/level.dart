import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:space_punks/actors/door.dart';
import 'package:space_punks/actors/enemy.dart';
import 'package:space_punks/actors/key.dart';
import 'package:space_punks/actors/moving_platform.dart';
import 'package:space_punks/actors/platform.dart';
import 'package:space_punks/actors/player.dart';
import 'package:space_punks/actors/teleporter.dart';
import 'package:tiled/tiled.dart';


import '../actors/background.dart';
import '../game/game_main.dart';

class Level extends Component with HasGameRef<GameMain> {
  final String levelName;
  late Player player;
  late Rect levelBounds;

  late Background background;

  //late BackgroundComponent backgroundComponent;

  Level(this.levelName) : super();

  @override
  Future<void>? onLoad() async {
    final level = await TiledComponent.load(levelName, Vector2.all(64));
    //backgroundComponent = BackgroundComponent();

    levelBounds = Rect.fromLTWH(
        0,
        0,
        (level.tileMap.map.width * level.tileMap.map.tileWidth).toDouble(),
        (level.tileMap.map.height * level.tileMap.map.tileHeight).toDouble());

    await setBackground(level.tileMap);
    await add(level);
    await spawnActors(level.tileMap);
    await setupCamera();
    return super.onLoad();
  }

  setBackground(RenderableTiledMap tileMap) async {
    var bkgLayer = tileMap.getLayer<ImageLayer>('BackgroundLayer');
    var myImagePath = bkgLayer!.image.source;
    Image myImage = await gameRef.images.load(myImagePath!);
    print('Image Source: $myImage');


    final bkg =
    Background(myImage, position: Vector2(0, 0), size: Vector2(1920, 1280));
    await add(bkg);
  }

  spawnActors(RenderableTiledMap tileMap) async {

    final platformsLayer = tileMap.getLayer<ObjectGroup>('PlatformsLayer');

    for (final platformObject in platformsLayer!.objects) {
      final platform = Platform(
        position: Vector2(platformObject.x, platformObject.y),
        size: Vector2(platformObject.width, platformObject.height),
      );
      await add(platform);
    }

    final spawnPointsLayer = tileMap.getLayer<ObjectGroup>('SpawnLayer');
    for (final spawnPoint in spawnPointsLayer!.objects) {
      final position = Vector2(spawnPoint.x, spawnPoint.y - spawnPoint.height);
      final size = Vector2(spawnPoint.width, spawnPoint.height);
      switch (spawnPoint.name) {

        case 'Player':
          player = Player(gameRef.punky,
              anchor: Anchor.center,
              levelBounds: levelBounds,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: size,
              priority: 2);
          await add(player);
          break;

      /* case 'Star':
          final star =
          Star(gameRef.spriteSheet, position: position, size: size);
          add(star);
          break;*/

        case 'Door':
          final door = Door(gameRef.spritesheet, position: position, size: size,
              onPlayerEnter: () {
                gameRef.loadLevel(spawnPoint.properties.first.value);
              });

          add(door);
          break;

       case 'Teleporter':
          final targetObjectId = int.parse(spawnPoint.properties.first.value);
          final teleporter = Teleporter(gameRef.spritesheet,
              position: position, size: size, onPlayerEnter: () {
                final target = spawnPointsLayer.objects
                    .firstWhere((object) => object.id == targetObjectId);
                player.teleportToPosition(Vector2(target.x, target.y));
              });
          add(teleporter);
          break;

        case 'Key':
          final key = Key(
            gameRef.spritesheet,
            position: position,
            size: size,
          );
          add(key);
          break;

        case 'Enemy':
          final targetObjectId = int.parse(spawnPoint.properties.first.value);
          final target = spawnPointsLayer.objects
              .firstWhere((object) => object.id == targetObjectId);
          final enemy = Enemy(gameRef.spritesheet,
              position: position,
              targetPosition: Vector2(target.x, target.y),
              size: size);
          add(enemy);
          break;



       case 'MovingPlatform':
          final targetObjectId = int.parse(spawnPoint.properties.first.value);
          final target = spawnPointsLayer.objects
              .firstWhere((object) => object.id == targetObjectId);
          final movingPlatform = MovingPlatform(gameRef.spritesheet,
              position: position,
              targetPosition: Vector2(target.x, target.y),
              size: size);
          add(movingPlatform);
          break;
      }
    }
  }

  setupCamera() {
    gameRef.camera.followComponent(player);
    gameRef.camera.worldBounds = levelBounds;
  }
}