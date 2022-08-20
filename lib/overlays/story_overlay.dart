import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:space_punks/game/game_main.dart';
import 'package:space_punks/overlays/hud_overlay.dart';



class StoryOverlay extends StatefulWidget {
  static const id = 'StoryOverlay';
  final GameMain gameRef;

  const StoryOverlay({Key? key, required this.gameRef}) : super(key: key);

  @override
  StoryOverlayState createState() => StoryOverlayState();
}

class StoryOverlayState extends State<StoryOverlay> {


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


    return Center(
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black.withOpacity(1.0),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 100),
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Image.asset('assets/images/tut3_gif.gif'),
                MaterialButton(
                  onPressed: () {
                    gameRef.overlays.remove(StoryOverlay.id);
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