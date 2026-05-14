import 'package:flutter/material.dart';
import '../models/ludo_models.dart';

class GameEngine {
  // Standard Ludo Path Offsets
  static int getStartOffset(LudoColor color) {
    switch (color) {
      case LudoColor.red: return 0;
      case LudoColor.green: return 13;
      case LudoColor.blue: return 26;
      case LudoColor.yellow: return 39;
    }
    return 0;
  }

  static int getHomeEntryIndex(LudoColor color) {
    switch (color) {
      case LudoColor.red: return 50;
      case LudoColor.green: return 11;
      case LudoColor.blue: return 24;
      case LudoColor.yellow: return 37;
    }
    return 0;
  }

  static Offset getCellOffset(int position, LudoColor color) {
    if (position == -1) return const Offset(0, 0);
    
    if (position >= 0 && position <= 51) {
      // Rotate global path based on player start
      int globalIndex = (position + getStartOffset(color)) % 52;
      return _fullPath[globalIndex];
    }

    if (position >= 52 && position <= 57) {
      return _getHomeStretchOffset(position - 52, color);
    }

    return const Offset(7, 7); // Center
  }

  static final List<Offset> _fullPath = [
    // Red Start area (Top-Left side)
    const Offset(1, 6), const Offset(2, 6), const Offset(3, 6), const Offset(4, 6), const Offset(5, 6),
    const Offset(6, 5), const Offset(6, 4), const Offset(6, 3), const Offset(6, 2), const Offset(6, 1), const Offset(6, 0),
    const Offset(7, 0), const Offset(8, 0), // Top middle
    // Green area (Top-Right side)
    const Offset(8, 1), const Offset(8, 2), const Offset(8, 3), const Offset(8, 4), const Offset(8, 5),
    const Offset(9, 6), const Offset(10, 6), const Offset(11, 6), const Offset(12, 6), const Offset(13, 6), const Offset(14, 6),
    const Offset(14, 7), const Offset(14, 8), // Right middle
    // Blue area (Bottom-Right side)
    const Offset(13, 8), const Offset(12, 8), const Offset(11, 8), const Offset(10, 8), const Offset(9, 8),
    const Offset(8, 9), const Offset(8, 10), const Offset(8, 11), const Offset(8, 12), const Offset(8, 13), const Offset(8, 14),
    const Offset(7, 14), const Offset(6, 14), // Bottom middle
    // Yellow area (Bottom-Left side)
    const Offset(6, 13), const Offset(6, 12), const Offset(6, 11), const Offset(6, 10), const Offset(6, 9),
    const Offset(5, 8), const Offset(4, 8), const Offset(3, 8), const Offset(2, 8), const Offset(1, 8), const Offset(0, 8),
    const Offset(0, 7), const Offset(0, 6), // Left middle
  ];

  static Offset _getHomeStretchOffset(int index, LudoColor color) {
    if (index >= 5) return const Offset(7, 7); // Center goal

    switch (color) {
      case LudoColor.red:
        return Offset((index + 1).toDouble(), 7.0);
      case LudoColor.green:
        return Offset(7.0, (index + 1).toDouble());
      case LudoColor.blue:
        return Offset(7.0, (13.0 - index));
      case LudoColor.yellow:
        return Offset((13.0 - index), 7.0);
    }
    return const Offset(7, 7);
  }
}
