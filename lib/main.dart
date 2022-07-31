import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'game/game_main.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();

  final _game = GameMain();

  runApp(GameWidget(game: _game));
}



/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var gameMain = _game;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jungle Adventure',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
          body:  gameMain),
    );
  }
}*/