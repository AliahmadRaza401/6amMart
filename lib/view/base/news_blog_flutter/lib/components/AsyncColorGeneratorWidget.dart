import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:palette_generator/palette_generator.dart';

class AsyncColorGeneratorWidget extends StatelessWidget {
  final String? image;

  AsyncColorGeneratorWidget({required this.image});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaletteGenerator>(
      future: AsyncMemoizer<PaletteGenerator>().runOnce(() => PaletteGenerator.fromImageProvider(NetworkImage(image.validate()))),
      builder: (context, snap) {
        if (snap.hasData) {
          return Container(
            width: context.width(),
            height: context.height(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.transparent, snap.data!.dominantColor!.color],
                stops: [0.0, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.mirror,
              ),
            ),
          );
        }
        return Container(
          width: context.width(),
          height: context.height(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              stops: [0.0, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.mirror,
            ),
          ),
        );
      },
    );
  }
}
