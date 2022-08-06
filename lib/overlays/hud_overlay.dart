import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:space_punks/game/game_main.dart';
import 'package:space_punks/overlays/pause_overlay.dart';


class HudOverlay extends StatefulWidget {
  static const id = 'HudOverlay';
  final GameMain gameRef;

  const HudOverlay({Key? key, required this.gameRef}) : super(key: key);

  @override
  HudOverlayState createState() => HudOverlayState();
}

class HudOverlayState extends State<HudOverlay> {
  @override
  Widget build(BuildContext context) {
    var gameRef = widget.gameRef;
    var box = GetStorage();

    return SizedBox(
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.score,
                  builder: (context, value, child) {
                    return Text(
                      'Score: ${value.toString()}',
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.highScore,
                  builder: (context, value, child) {
                    return Text(
                      'High: ${value.toString()}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    );
                  },
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                gameRef.pauseEngine();
                gameRef.saveHighScore();
                gameRef.overlays.add(PauseOverlay.id);
                gameRef.overlays.remove(HudOverlay.id);
                box.write('high_score', gameRef.high);
              },
              icon: const Icon(Icons.pause_circle),
              color: Colors.white,
              iconSize: 35,
            ),

            Row(
              children: [
                Image.asset('assets/images/star.png'),
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.bonusLifePointCount,
                  builder: (context, value, child) {
                    return Text(
                      '${value.toString()} / 100',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    );
                  },
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.key,
                  builder: (context, value, child) {
                    return value == true
                        ? Image.asset('assets/images/key_24.png')
                        : Image.asset('assets/images/clear_24.png');
                  },
                ),
                Image.asset('assets/images/bob_profile.png'),
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.health,
                  builder: (context, value, child) {
                    return Text(
                      'x${value.toString()}',
                      style: const TextStyle(fontSize: 22, color: Colors.white),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}