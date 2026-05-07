import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_state.dart';
import '../core/theme.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class ModeToggle extends StatelessWidget {
  const ModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isGoxey = appState.isGoxeyMode;

    return GestureDetector(
      onTap: () {
        appState.toggleMode();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        width: 110,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isGoxey
              ? const LinearGradient(
                  colors: [GoXeyColors.blackRussian, Color(0xFF1a1c29)],
                )
              : const LinearGradient(
                  colors: [Colors.white24, Colors.white10],
                ),
          border: Border.all(
            color: isGoxey ? GoXeyColors.accentPurple.withOpacity(0.5) : Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            if (isGoxey)
              BoxShadow(
                color: GoXeyColors.accentPurple.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              )
          ],
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: isGoxey ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 50,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isGoxey ? GoXeyColors.accentPurple : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "GX",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isGoxey ? Colors.white54 : GoXeyColors.accentPurple,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "GoXey",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isGoxey ? Colors.white : Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
