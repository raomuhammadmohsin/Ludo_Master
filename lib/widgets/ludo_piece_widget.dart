import 'package:flutter/material.dart';
import '../models/ludo_models.dart';
import '../logic/game_engine.dart';
import '../constants/app_colors.dart';

class LudoPieceWidget extends StatelessWidget {
  final LudoPiece piece;
  final double boardSize;
  final VoidCallback onTap;

  const LudoPieceWidget({
    super.key,
    required this.piece,
    required this.boardSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double cellSize = boardSize / 15;
    Offset offset;

    if (piece.position == -1) {
      offset = _getBaseOffset(piece, cellSize);
    } else {
      offset = GameEngine.getCellOffset(piece.position, piece.color);
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: offset.dx * cellSize,
      top: offset.dy * cellSize,
      child: GestureDetector(
        onTap: piece.isAtHome ? null : onTap,
        child: Opacity(
          opacity: piece.isAtHome ? 0.8 : 1.0,
          child: Container(
            width: cellSize,
            height: cellSize,
            padding: const EdgeInsets.all(4),
            child: _buildClassicPiece(cellSize),
          ),
        ),
      ),
    );
  }

  Widget _buildClassicPiece(double cellSize) {
    Color color = _getColor();
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.4),
            color,
            Colors.black.withOpacity(0.2),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
      ),
      child: Center(
        child: Container(
          width: cellSize * 0.4,
          height: cellSize * 0.4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
            color: Colors.black12,
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (piece.color) {
      case LudoColor.red: return AppColors.playerRed;
      case LudoColor.green: return AppColors.playerGreen;
      case LudoColor.yellow: return AppColors.playerYellow;
      case LudoColor.blue: return AppColors.playerBlue;
    }
  }

  Offset _getBaseOffset(LudoPiece piece, double cellSize) {
    double x = 0, y = 0;
    switch (piece.color) {
      case LudoColor.red: x = 0.5; y = 0.5; break;
      case LudoColor.green: x = 9.5; y = 0.5; break;
      case LudoColor.blue: x = 9.5; y = 9.5; break;
      case LudoColor.yellow: x = 0.5; y = 9.5; break;
    }
    
    switch (piece.id) {
      case 0: return Offset(x + 1, y + 1);
      case 1: return Offset(x + 3, y + 1);
      case 2: return Offset(x + 1, y + 3);
      case 3: return Offset(x + 3, y + 3);
      default: return Offset(x, y);
    }
  }
}
