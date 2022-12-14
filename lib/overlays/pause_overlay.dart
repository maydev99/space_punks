import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:space_punks/game/game_main.dart';
import 'package:space_punks/overlays/hud_overlay.dart';



class PauseOverlay extends StatefulWidget {
  static const id = 'PauseOverlay';
  final GameMain gameRef;

  const PauseOverlay({Key? key, required this.gameRef}) : super(key: key);

  @override
  PauseOverlayState createState() => PauseOverlayState();
}

class PauseOverlayState extends State<PauseOverlay> {


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
    box.write('high_score', gameRef.high);

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
                Text('Game Paused',
                    style: GoogleFonts.chewy(
                        textStyle: const TextStyle(
                            color: Colors.greenAccent, fontSize: 50))),
                MaterialButton(
                  onPressed: () {
                    gameRef.overlays.remove(PauseOverlay.id);
                    gameRef.resumeEngine();
                    gameRef.overlays.add(HudOverlay.id);

                    //AudioManager.instance.resumeBgm();
                    // createGeneralNotification();
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: const Text('Resume Game'),
                ),


              ],
            ),
          ),
        ),
      ),
    );

  }
}