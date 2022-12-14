import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:logger/logger.dart';
import 'package:space_punks/game/game_main.dart';
import 'package:space_punks/overlays/hud_overlay.dart';



class GameOverOverlay extends StatefulWidget {
  static const id = 'GameOverOverlay';
  final GameMain gameRef;

  const GameOverOverlay({Key? key, required this.gameRef}) : super(key: key);

  @override
  GameOverOverlayState createState() => GameOverOverlayState();
}

class GameOverOverlayState extends State<GameOverOverlay> {


  var log = Logger();
  var box = GetStorage();


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var gameRef = widget.gameRef;
    box.write('high_score', gameRef.playerData.highScore.value);

    return Center(
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black.withOpacity(0.5),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 100),
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Game Over',
                    style: GoogleFonts.chewy(
                        textStyle: const TextStyle(
                            color: Colors.greenAccent, fontSize: 50))),
                MaterialButton(
                  onPressed: () {
                    gameRef.restartGame();
                    gameRef.loadLevel('pre_level_1.tmx');
                    gameRef.resumeEngine();
                    gameRef.overlays.remove(GameOverOverlay.id);
                    gameRef.overlays.add(HudOverlay.id);

                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: const Text('Restart Game'),
                ),


              ],
            ),
          ),
        ),
      ),
    );

  }
}