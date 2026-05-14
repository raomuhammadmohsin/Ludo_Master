import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/ludo_models.dart';

class LudoBoardPainter extends CustomPainter {
  final List<LudoColor> activeColors;

  LudoBoardPainter({required this.activeColors});

  @override
  void paint(Canvas canvas, Size size) {
    double cellSize = size.width / 15;

    // 1. Wooden Frame
    final framePaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(Rect.fromLTWH(-5, -5, size.width + 10, size.height + 10), framePaint);

    // 2. Main Background
    final bgPaint = Paint()..color = const Color(0xFFFFF9C4);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 3. Grid Lines
    final gridPaint = Paint()..color = Colors.black.withOpacity(0.1)..style = PaintingStyle.stroke;
    for (int i = 0; i <= 15; i++) {
      canvas.drawLine(Offset(i * cellSize, 0), Offset(i * cellSize, size.height), gridPaint);
      canvas.drawLine(Offset(0, i * cellSize), Offset(size.width, i * cellSize), gridPaint);
    }

    // 4. Draw All Bases (Keep them colorful as requested)
    _drawBase(canvas, cellSize, 0, 0, AppColors.playerRed);
    _drawBase(canvas, cellSize, 9, 0, AppColors.playerGreen);
    _drawBase(canvas, cellSize, 9, 9, AppColors.playerBlue);
    _drawBase(canvas, cellSize, 0, 9, AppColors.playerYellow);

    // 5. Draw All Home Stretches
    _drawHomeStretch(canvas, cellSize, 1, 7, AppColors.playerRed, true);
    _drawHomeStretch(canvas, cellSize, 7, 1, AppColors.playerGreen, false);
    _drawHomeStretch(canvas, cellSize, 7, 9, AppColors.playerBlue, false);
    _drawHomeStretch(canvas, cellSize, 9, 7, AppColors.playerYellow, true);

    // 6. Draw Start Cells
    _drawStartCell(canvas, cellSize, 1, 6, AppColors.playerRed);
    _drawStartCell(canvas, cellSize, 8, 1, AppColors.playerGreen);
    _drawStartCell(canvas, cellSize, 13, 8, AppColors.playerBlue);
    _drawStartCell(canvas, cellSize, 6, 13, AppColors.playerYellow);

    // 7. Center Home
    _drawCenterHome(canvas, size, cellSize);
  }

  void _drawBase(Canvas canvas, double cellSize, double x, double y, Color color) {
    canvas.drawRect(Rect.fromLTWH(x * cellSize, y * cellSize, 6 * cellSize, 6 * cellSize), Paint()..color = color);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH((x + 0.8) * cellSize, (y + 0.8) * cellSize, 4.4 * cellSize, 4.4 * cellSize), const Radius.circular(10)),
      Paint()..color = Colors.white,
    );
    // Circles for pieces positions
    final p = Paint()..color = color.withOpacity(0.2);
    for (var pos in [Offset(x + 2, y + 2), Offset(x + 4, y + 2), Offset(x + 2, y + 4), Offset(x + 4, y + 4)]) {
      canvas.drawCircle(pos * cellSize, cellSize * 0.65, p);
    }
  }

  void _drawHomeStretch(Canvas canvas, double cellSize, double x, double y, Color color, bool isHorizontal) {
    final p = Paint()..color = color;
    for (int i = 0; i < 5; i++) {
      double dx = isHorizontal ? (x + i) * cellSize : x * cellSize;
      double dy = isHorizontal ? y * cellSize : (y + i) * cellSize;
      canvas.drawRect(Rect.fromLTWH(dx, dy, cellSize, cellSize), p);
    }
  }

  void _drawStartCell(Canvas canvas, double cellSize, double x, double y, Color color) {
    canvas.drawRect(Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize), Paint()..color = color);
    double r = cellSize * 0.3;
    Offset c = Offset((x + 0.5) * cellSize, (y + 0.5) * cellSize);
    canvas.drawLine(c + Offset(-r, -r), c + Offset(r, r), Paint()..color = Colors.black12..strokeWidth = 2);
    canvas.drawLine(c + Offset(r, -r), c + Offset(-r, r), Paint()..color = Colors.black12..strokeWidth = 2);
  }

  void _drawCenterHome(Canvas canvas, Size size, double cellSize) {
    final center = size.width / 2;
    void drawTri(List<Offset> pts, Color c) => canvas.drawPath(Path()..addPolygon(pts, true), Paint()..color = c);
    drawTri([Offset(6 * cellSize, 6 * cellSize), Offset(center, center), Offset(6 * cellSize, 9 * cellSize)], AppColors.playerRed);
    drawTri([Offset(6 * cellSize, 6 * cellSize), Offset(center, center), Offset(9 * cellSize, 6 * cellSize)], AppColors.playerGreen);
    drawTri([Offset(9 * cellSize, 6 * cellSize), Offset(center, center), Offset(9 * cellSize, 9 * cellSize)], AppColors.playerBlue);
    drawTri([Offset(6 * cellSize, 9 * cellSize), Offset(center, center), Offset(9 * cellSize, 9 * cellSize)], AppColors.playerYellow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
