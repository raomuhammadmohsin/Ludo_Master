import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ludo_provider.dart';
import 'ludo_board_painter.dart';
import 'ludo_piece_widget.dart';
import '../models/ludo_models.dart';

class LudoBoard extends ConsumerWidget {
  const LudoBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ludoProvider);
    final activeColors = state.players.map((p) => p.color).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        double boardSize = constraints.maxWidth;
        if (boardSize > constraints.maxHeight) boardSize = constraints.maxHeight;

        return Center(
          child: SizedBox(
            width: boardSize,
            height: boardSize,
            child: Stack(
              children: [
                // Static Board Grid with Active Colors only
                CustomPaint(
                  size: Size(boardSize, boardSize),
                  painter: LudoBoardPainter(activeColors: activeColors),
                ),
                
                // Active Player Pieces
                ...state.players.expand((p) => p.pieces).map((piece) {
                  return LudoPieceWidget(
                    piece: piece,
                    boardSize: boardSize,
                    onTap: () => ref.read(ludoProvider.notifier).movePiece(piece.id),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
