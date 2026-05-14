import 'package:flutter/material.dart';

enum LudoColor { red, blue, green, yellow }

// ChatMessage has been moved to ludo_provider.dart to avoid type errors

class LudoPiece {
  final int id;
  final LudoColor color;
  int position; 
  bool isAtHome;

  LudoPiece({
    required this.id,
    required this.color,
    this.position = -1,
    this.isAtHome = false,
  });

  LudoPiece copyWith({int? position, bool? isAtHome}) {
    return LudoPiece(
      id: id,
      color: color,
      position: position ?? this.position,
      isAtHome: isAtHome ?? this.isAtHome,
    );
  }
}

class Player {
  final String name;
  final LudoColor color;
  final List<LudoPiece> pieces;
  final bool isHuman;
  bool isTurn;

  Player({
    required this.name,
    required this.color,
    required this.pieces,
    this.isHuman = true,
    this.isTurn = false,
  });

  static Player defaultPlayer(LudoColor color, String name) {
    return Player(
      name: name,
      color: color,
      pieces: List.generate(4, (index) => LudoPiece(id: index, color: color)),
    );
  }
}
