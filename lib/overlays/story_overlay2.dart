import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:space_punks/game/game_main.dart';
import 'package:space_punks/overlays/hud_overlay.dart';

class StoryOverlay2 extends StatefulWidget {
  static const id = 'StoryOverlay2';
  final GameMain gameRef;

  const StoryOverlay2({Key? key, required this.gameRef}) : super(key: key);

  @override
  StoryOverlay2State createState() => StoryOverlay2State();
}

class StoryOverlay2State extends State<StoryOverlay2> {
  var log = Logger();
  var box = GetStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gameRef = widget.gameRef;
    /*var premium = box.read('premium') ?? false;
    var isGameWon = box.read('game_won') ?? false;*/

    return Container(
      color: Colors.black,
      width: gameRef.screenX,
      height: gameRef.screenY,
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: gameRef.playerData.storyText,
            builder: (context, value, child) {
              return Text(value.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              );
            },

          ),
          ValueListenableBuilder(
            valueListenable: gameRef.playerData.storyImage,
            builder: (context, value, child) {
              return Image.asset(value.toString(),
                width: 600,
                height: 300,
              );
            },

          ),
          MaterialButton(
            onPressed: () {
              gameRef.overlays.remove(StoryOverlay2.id);
              gameRef.resumeEngine();
              gameRef.overlays.add(HudOverlay.id);

              //AudioManager.instance.resumeBgm();
              // createGeneralNotification();
            },
            color: Colors.blue,
            elevation: 10,
            textColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Text('Continue'),
          ),
        ],
      )
    );

  }
}
