import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game_screen.dart';
import '../constants/app_colors.dart';
import '../providers/ludo_provider.dart';

class PlayerSelectionScreen extends ConsumerWidget {
  const PlayerSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF5D4037)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SELECT PLAYERS",
              style: GoogleFonts.philosopher(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5D4037),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "How many of you are playing?",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black45),
            ),
            const SizedBox(height: 50),
            
            _buildSelectionCard(
              context,
              ref,
              "2 PLAYERS",
              "Red vs Yellow (Cross Mode)",
              Icons.person_outline_rounded,
              AppColors.playerRed,
              2,
            ),
            const SizedBox(height: 20),
            _buildSelectionCard(
              context,
              ref,
              "4 PLAYERS",
              "Full House (All Colors)",
              Icons.people_outline_rounded,
              AppColors.playerGreen,
              4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard(BuildContext context, WidgetRef ref, String title, String sub, IconData icon, Color color, int count) {
    return GestureDetector(
      onTap: () {
        ref.read(ludoProvider.notifier).startGame(count);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded( // Fixes the overflow issue
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black45,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios_rounded, color: color.withOpacity(0.5), size: 18),
          ],
        ),
      ),
    );
  }
}
