import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/ludo_provider.dart';
import '../constants/app_colors.dart';

class DiceWidget extends ConsumerWidget {
  const DiceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ludoProvider);
    final isRolling = state.status == GameStatus.rolling;

    return GestureDetector(
      onTap: () => ref.read(ludoProvider.notifier).rollDice(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: isRolling
            ? Spin(
                infinite: true,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: AppColors.accentGold.withOpacity(0.5), blurRadius: 15),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.refresh, color: Colors.black, size: 30),
                  ),
                ),
              )
            : ZoomIn(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black54, blurRadius: 10),
                    ],
                    border: Border.all(color: AppColors.accentGold, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      state.diceValue.toString(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
