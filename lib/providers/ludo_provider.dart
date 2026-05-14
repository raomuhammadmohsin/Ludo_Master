import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ludo_models.dart';
import '../logic/game_engine.dart';
import 'dart:math';

enum GameStatus { idle, rolling, moving, finished }

class ChatMessage {
  final String text;
  final String senderName;
  final LudoColor senderColor;

  ChatMessage({
    required this.text,
    required this.senderName,
    required this.senderColor,
  });
}

class LudoState {
  final List<Player> players;
  final int currentTurnIndex;
  final int diceValue;
  final GameStatus status;
  final String message;
  final List<ChatMessage> messages;
  final int playerCount;

  LudoState({
    required this.players,
    this.currentTurnIndex = 0,
    this.diceValue = 1,
    this.status = GameStatus.idle,
    this.message = "Red's Turn",
    this.messages = const [],
    this.playerCount = 4,
  });

  LudoState copyWith({
    List<Player>? players,
    int? currentTurnIndex,
    int? diceValue,
    GameStatus? status,
    String? message,
    List<ChatMessage>? messages,
    int? playerCount,
  }) {
    return LudoState(
      players: players ?? this.players,
      currentTurnIndex: currentTurnIndex ?? this.currentTurnIndex,
      diceValue: diceValue ?? this.diceValue,
      status: status ?? this.status,
      message: message ?? this.message,
      messages: messages ?? this.messages,
      playerCount: playerCount ?? this.playerCount,
    );
  }
}

class LudoNotifier extends Notifier<LudoState> {
  @override
  LudoState build() {
    return LudoState(
      players: _getInitialPlayers(4),
    );
  }

  List<Player> _getInitialPlayers(int count) {
    if (count == 2) {
      return [
        Player.defaultPlayer(LudoColor.red, "Player 1"),
        Player.defaultPlayer(LudoColor.blue, "Player 2"),
      ];
    } else {
      return [
        Player.defaultPlayer(LudoColor.red, "Player 1"),
        Player.defaultPlayer(LudoColor.green, "Player 2"),
        Player.defaultPlayer(LudoColor.blue, "Player 3"),
        Player.defaultPlayer(LudoColor.yellow, "Player 4"),
      ];
    }
  }

  void startGame(int count) {
    state = LudoState(
      players: _getInitialPlayers(count),
      playerCount: count,
      message: "Red's Turn",
    );
  }

  void resetGame() {
    startGame(state.playerCount);
  }

  // Updated to allow any player to send message
  void sendMessage(String msg, Player sender) {
    final chatMsg = ChatMessage(
      text: msg,
      senderName: sender.name,
      senderColor: sender.color,
    );
    state = state.copyWith(messages: [...state.messages, chatMsg]);
  }

  void rollDice() async {
    if (state.status != GameStatus.idle) return;

    state = state.copyWith(status: GameStatus.rolling);
    await Future.delayed(const Duration(milliseconds: 500));
    
    final value = Random().nextInt(6) + 1;
    state = state.copyWith(
      diceValue: value,
      status: GameStatus.moving,
      message: "Value: $value",
    );

    if (!_anyMovesPossible(value)) {
      state = state.copyWith(message: "No moves!");
      await Future.delayed(const Duration(milliseconds: 800));
      nextTurn();
    }
  }

  bool _anyMovesPossible(int value) {
    final player = state.players[state.currentTurnIndex];
    for (var piece in player.pieces) {
      if (piece.position == -1) {
        if (value == 6) return true;
        continue;
      }
      if (piece.position + value <= 57) {
        return true;
      }
    }
    return false;
  }

  void movePiece(int pieceId) async {
    if (state.status != GameStatus.moving) return;

    final player = state.players[state.currentTurnIndex];
    final piece = player.pieces[pieceId];

    if (piece.isAtHome) return;

    final diceValue = state.diceValue;

    int newPosition = piece.position;
    bool finished = false;

    if (piece.position == -1) {
      if (diceValue == 6) {
        newPosition = 0;
      } else {
        return;
      }
    } else if (piece.position + diceValue <= 57) {
      newPosition += diceValue;
      if (newPosition == 57) finished = true;
    } else {
      return;
    }

    List<Player> updatedPlayers = List.from(state.players);
    List<LudoPiece> updatedPieces = List.from(player.pieces);
    updatedPieces[pieceId] = piece.copyWith(position: newPosition, isAtHome: finished);
    updatedPlayers[state.currentTurnIndex] = Player(
      name: player.name,
      color: player.color,
      pieces: updatedPieces,
      isTurn: player.isTurn,
      isHuman: player.isHuman,
    );

    if (newPosition >= 0 && newPosition <= 51) {
      int globalPos = (newPosition + GameEngine.getStartOffset(player.color)) % 52;
      
      for (int i = 0; i < updatedPlayers.length; i++) {
        if (i == state.currentTurnIndex) continue;
        
        var otherPlayer = updatedPlayers[i];
        var otherPieces = List<LudoPiece>.from(otherPlayer.pieces);
        bool killed = false;

        for (int j = 0; j < otherPieces.length; j++) {
          var otherPiece = otherPieces[j];
          if (otherPiece.position >= 0 && otherPiece.position <= 51) {
             int otherGlobalPos = (otherPiece.position + GameEngine.getStartOffset(otherPlayer.color)) % 52;
             if (globalPos == otherGlobalPos) {
               if (!_isSafeZone(globalPos)) {
                 otherPieces[j] = otherPiece.copyWith(position: -1);
                 killed = true;
               }
             }
          }
        }

        if (killed) {
          updatedPlayers[i] = Player(
            name: otherPlayer.name,
            color: otherPlayer.color,
            pieces: otherPieces,
            isTurn: otherPlayer.isTurn,
            isHuman: otherPlayer.isHuman,
          );
        }
      }
    }

    state = state.copyWith(players: updatedPlayers);

    // Check Win Condition
    bool playerWins = updatedPieces.every((p) => p.isAtHome);
    if (playerWins) {
      state = state.copyWith(
        status: GameStatus.finished,
        message: "${player.name} (${player.color.name.toUpperCase()}) WINS!",
      );
      return;
    }

    if (diceValue == 6 || finished) {
      state = state.copyWith(status: GameStatus.idle, message: "Roll again!");
    } else {
      nextTurn();
    }
  }

  bool _isSafeZone(int globalPos) {
    const safeZones = [0, 8, 13, 21, 26, 34, 39, 47];
    return safeZones.contains(globalPos);
  }

  void nextTurn() {
    int nextIndex = (state.currentTurnIndex + 1) % state.playerCount;
    state = state.copyWith(
      currentTurnIndex: nextIndex,
      status: GameStatus.idle,
      message: "${state.players[nextIndex].color.name.toUpperCase()}'s Turn",
    );
  }
}

final ludoProvider = NotifierProvider<LudoNotifier, LudoState>(() {
  return LudoNotifier();
});
