
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:space_punks/game/game_main.dart';

class ToastOverlay extends StatefulWidget {
  static const id = 'ToastOverlay';
  final GameMain gameRef;

  const ToastOverlay({Key? key, required this.gameRef}) : super(key: key);

  @override
  ToastOverlayState createState() => ToastOverlayState();
}

class ToastOverlayState extends State<ToastOverlay> {
  var log = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gameRef = widget.gameRef;

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.black.withOpacity(0.1),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 100),
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: gameRef.playerData.toast,
                  builder: (context, value, child) {
                    return Text(
                      value.toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}