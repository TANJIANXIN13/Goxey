import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../core/theme.dart';
import 'glass_container.dart';

class RoastCard extends StatelessWidget {
  final String roastMessage;

  const RoastCard({
    super.key,
    this.roastMessage = "RM40 on Grab Food? Are your legs broken? Walk to the kitchen, chef.",
  });

  @override
  Widget build(BuildContext context) {
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
                    Icons.whatshot,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    "ROAST MODE AI",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: GoXeyColors.radicalRed,
                          fontWeight: FontWeight.bold,
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
              roastMessage,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.trending_down,
                  color: Colors.white54,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  "Financial damage: CRITICAL",
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
  }
}
