import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/pocket_provider.dart';
import 'glass_container.dart';

class RoastCard extends StatelessWidget {
  const RoastCard({super.key});

  String _getAdvice(double saved, double target) {
    if (target == 0) return "Start saving, slacker. Your bank account is drier than a Popeyes biscuit.";
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

  @override
  Widget build(BuildContext context) {
    return Consumer<PocketProvider>(
      builder: (context, pocketProvider, child) {
        final totalSaved = pocketProvider.totalSaved;
        final totalTarget = pocketProvider.pockets.fold(0.0, (sum, p) => sum + p.target);
        final advice = _getAdvice(totalSaved, totalTarget);

        return FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: GlassContainer(
            padding: const EdgeInsets.all(20),
            opacity: 0.05,
            border: Border.all(
              color: GoXeyColors.radicalRed.withOpacity(0.3),
              width: 1.5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: GoXeyColors.radicalRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "AI ADVICE",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: GoXeyColors.radicalRed,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.more_horiz,
                      color: Colors.white54,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  advice,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.3,
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white54,
                          ),
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
