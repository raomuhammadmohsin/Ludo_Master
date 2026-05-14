import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/ludo_board.dart';
import '../widgets/dice_widget.dart';
import '../widgets/chat_bottom_sheet.dart';
import '../providers/ludo_provider.dart';
import '../constants/app_colors.dart';
import '../models/ludo_models.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ludoProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(color: AppColors.background),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(state, context, ref),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const LudoBoard(),
                            const SizedBox(height: 20),
                            _buildControls(state, ref),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ..._buildPlayerCards(state, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(LudoState state, BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _buildHeaderButton(
              icon: Icons.replay_rounded,
              color: AppColors.playerRed,
              onTap: () => ref.read(ludoProvider.notifier).resetGame(),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "LUDO MASTER",
                style: GoogleFonts.philosopher(
                  color: const Color(0xFF5D4037),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              Container(height: 2, width: 100, color: AppColors.accentGold),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildHeaderButton(
              icon: Icons.chat_rounded,
              color: AppColors.playerBlue,
              onTap: () => _showChat(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showChat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChatBottomSheet(),
    );
  }

  Widget _buildHeaderButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _buildControls(LudoState state, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.boardGrid, width: 2),
      ),
      child: Column(
        children: [
          Text(
            state.message,
            style: GoogleFonts.poppins(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 15),
          const DiceWidget(),
        ],
      ),
    );
  }

  List<Widget> _buildPlayerCards(LudoState state, BuildContext context) {
    return state.players.map((player) {
      bool isActive = state.players[state.currentTurnIndex].color == player.color;
      Offset pos = _getPlayerPosition(player.color);
      return Positioned(
        top: pos.dy,
        left: pos.dx != -1 ? pos.dx : null,
        right: pos.dx == -1 ? 10 : null,
        child: _PlayerCard(
          player: player,
          isActive: isActive,
          onChatTap: () => _showChat(context),
        ),
      );
    }).toList();
  }

  Offset _getPlayerPosition(LudoColor color) {
    // Matching positions with LudoBoardPainter
    switch (color) {
      case LudoColor.red: 
        return const Offset(10, 80); // Top Left
      case LudoColor.green: 
        return const Offset(-1, 80); // Top Right
      case LudoColor.yellow: 
        return const Offset(10, 550); // Bottom Left
      case LudoColor.blue: 
        return const Offset(-1, 550); // Bottom Right
    }
  }
}

class _PlayerCard extends StatelessWidget {
  final Player player;
  final bool isActive;
  final VoidCallback onChatTap;
  const _PlayerCard({required this.player, required this.isActive, required this.onChatTap});

  @override
  Widget build(BuildContext context) {
    Color color = _getColor();
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white70,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: isActive ? color : Colors.grey.shade400, width: isActive ? 3 : 1),
            boxShadow: isActive ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10)] : [],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(Icons.person_rounded, color: color, size: 20),
              ),
              const SizedBox(height: 2),
              Text(
                player.name,
                style: GoogleFonts.poppins(color: Colors.black87, fontSize: 9, fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: onChatTap,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withOpacity(0.8), shape: BoxShape.circle),
            child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 14),
          ),
        ),
      ],
    );
  }

  Color _getColor() {
    switch (player.color) {
      case LudoColor.red: return AppColors.playerRed;
      case LudoColor.green: return AppColors.playerGreen;
      case LudoColor.blue: return AppColors.playerBlue;
      case LudoColor.yellow: return AppColors.playerYellow;
    }
  }
}
