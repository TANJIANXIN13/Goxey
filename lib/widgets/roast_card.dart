import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../core/app_state.dart';
import '../core/theme.dart';
import '../core/pocket_provider.dart';
import 'glass_container.dart';

class RoastCard extends StatelessWidget {
  const RoastCard({super.key});

  String _getAdvice(double saved, double target) {
    if (target == 0)
      return "Start saving, slacker. Your bank account is drier than a Popeyes biscuit.";
    double percent = (saved / target) * 100;

    if (percent >= 100) {
      return "Goal reached? Don't get cocky. One Shopee spree and you're back in the trenches.";
    } else if (percent >= 50) {
      return "RM${saved.toStringAsFixed(0)} saved. Halfway there. Even a snail moves faster, but I guess it's progress.";
    } else if (percent > 0) {
      return "RM${saved.toStringAsFixed(0)}? That's barely enough for a fancy steak. Keep going before you go broke.";
    } else {
      return "RM0 saved? Your financial discipline is a myth. Put some money in your pockets, now.";
    }
  }

  Color _getColor(double saved, double target) {
    if (target == 0) return Colors.purple;
    double percent = (saved / target) * 100;
    if (percent >= 100) return Colors.green;
    if (percent >= 50) return Colors.blue;
    if (percent > 0) return Colors.orange;
    return GoXeyColors.radicalRed;
  }

  String _getEmoji(double saved, double target) {
    if (target == 0) return "😐";
    double percent = (saved / target) * 100;
    if (percent >= 100) return "😌";
    if (percent >= 50) return "🤔";
    if (percent > 0) return "🙄";
    return "🤬";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PocketProvider, AppState>(
      builder: (context, pocketProvider, appState, child) {
        final initialTotal = 7150.0;
        final currentTotal = pocketProvider.totalSaved + appState.totalBalance;
        final totalSaved = currentTotal - initialTotal;
        final totalTarget =
            10000.0; // Fixed milestone target that accommodates total balance
        final advice = _getAdvice(totalSaved, totalTarget);
        final cardColor = _getColor(totalSaved, totalTarget);
        final cardEmoji = _getEmoji(totalSaved, totalTarget);
        final isZero =
            totalTarget != 0 && (totalSaved / totalTarget) * 100 <= 0;

        return FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: GlassContainer(
            padding: const EdgeInsets.all(20),
            opacity: 0.05,
            border: Border.all(color: cardColor.withOpacity(0.3), width: 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    isZero
                        ? SizedBox(
                            width: 56,
                            height: 56,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  color: cardColor,
                                  size: 56,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    cardEmoji,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: cardColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              cardEmoji,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "AI ADVICE",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: cardColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.more_horiz, color: Colors.white54),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  advice,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Colors.white54,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Saving Summary: RM${totalSaved.toStringAsFixed(0)} / RM${totalTarget.toStringAsFixed(0)}",
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
