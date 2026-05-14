import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'player_selection_screen.dart';
import '../constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Icon(Icons.casino_rounded, size: 80, color: AppColors.playerRed),
            ),
            const SizedBox(height: 30),
            Text(
              "LUDO MASTER",
              style: GoogleFonts.philosopher(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5D4037),
                letterSpacing: 5,
              ),
            ),
            Text(
              "CLASSIC EDITION",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black38,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 60),
            
            _buildMenuButton(
              context,
              "LOCAL MULTIPLAYER",
              Icons.groups_rounded,
              AppColors.playerGreen,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerSelectionScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 15),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
