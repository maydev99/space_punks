import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_punks/game/game_main.dart';
import 'package:space_punks/overlays/game_over_overlay.dart';
import 'package:space_punks/overlays/hud_overlay.dart';
import 'package:space_punks/overlays/pause_overlay.dart';
import 'package:space_punks/overlays/toast_image_overlay.dart';
import 'package:space_punks/overlays/toast_overlay.dart';

GameMain _gameMain = GameMain();

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
          title: 'AppTitle',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: Scaffold(
            body: GameWidget(
              overlayBuilderMap: {
                HudOverlay.id: (_, GameMain gameRef) => HudOverlay(gameRef: _gameMain),
                PauseOverlay.id: (_, GameMain gameRef) => PauseOverlay(gameRef: _gameMain),
                ToastImageOverlay.id: (_,GameMain gameRef) => ToastImageOverlay(gameRef: _gameMain),
                ToastOverlay.id: (_, GameMain gameRef) => ToastOverlay(gameRef: _gameMain),
                GameOverOverlay.id: (_, GameMain gameRef) => GameOverOverlay(gameRef: _gameMain),

              },
              initialActiveOverlays: const [HudOverlay.id],
              game: _gameMain,
            ),
          )),
    );
  }
}
