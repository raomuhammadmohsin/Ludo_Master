import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/ludo_provider.dart';
import '../constants/app_colors.dart';
import '../models/ludo_models.dart';

class ChatBottomSheet extends ConsumerStatefulWidget {
  const ChatBottomSheet({super.key});

  @override
  ConsumerState<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends ConsumerState<ChatBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  int _selectedSenderIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ludoProvider);
    
    // Safety check for index
    if (_selectedSenderIndex >= state.players.length) {
      _selectedSenderIndex = 0;
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -5)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.boardGrid,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Text(
            "PLAYERS CHAT",
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D4037),
              letterSpacing: 2,
            ),
          ),
          const Divider(height: 30, indent: 20, endIndent: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final msg = state.messages[index];
                bool alignRight = msg.senderName.contains("2") || msg.senderName.contains("4");
                return _buildChatMessage(context, msg, alignRight);
              },
            ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildChatMessage(BuildContext context, ChatMessage message, bool alignRight) {
    Color senderColor = _getLudoColor(message.senderColor);
    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Column(
          crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.senderName,
              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: senderColor),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: senderColor.withOpacity(0.15),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(alignRight ? 15 : 0),
                  topRight: Radius.circular(alignRight ? 0 : 15),
                  bottomLeft: const Radius.circular(15),
                  bottomRight: const Radius.circular(15),
                ),
                border: Border.all(color: senderColor, width: 1),
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    final state = ref.read(ludoProvider); // Use latest state
    final players = state.players;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        children: [
          // Player Selector Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(players.length, (index) {
              final player = players[index];
              final isSelected = _selectedSenderIndex == index;
              final color = _getLudoColor(player.color);
              return GestureDetector(
                onTap: () => setState(() => _selectedSenderIndex = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? color : color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 16,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Speak as ${players[_selectedSenderIndex].name}...",
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.send_rounded, color: Color(0xFF5D4037)),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    final currentState = ref.read(ludoProvider);
                    ref.read(ludoProvider.notifier).sendMessage(
                      _controller.text,
                      currentState.players[_selectedSenderIndex],
                    );
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getLudoColor(LudoColor color) {
    switch (color) {
      case LudoColor.red: return AppColors.playerRed;
      case LudoColor.green: return AppColors.playerGreen;
      case LudoColor.blue: return AppColors.playerBlue;
      case LudoColor.yellow: return AppColors.playerYellow;
    }
  }
}
