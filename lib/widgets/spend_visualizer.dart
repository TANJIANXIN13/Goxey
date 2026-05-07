import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../core/theme.dart';

class SpendVisualizer extends StatelessWidget {
  final double amount;
  final String comparisonItem;
  final int count;

  const SpendVisualizer({
    super.key,
    required this.amount,
    required this.comparisonItem,
    required this.count,
  });

  static void show(BuildContext context, {required double amount, required String item, required int count}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SpendVisualizer(
        amount: amount,
        comparisonItem: item,
        count: count,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: GoXeyColors.blackRussian,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          Icon(
            LucideIcons.shopping_bag,
            color: GoXeyColors.neonLime,
            size: 48,
          ),
          const SizedBox(height: 24),
          Text(
            "CONGRATULATIONS!",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: GoXeyColors.neonLime,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
              children: [
                const TextSpan(text: "Today you've spent "),
                TextSpan(
                  text: "$count packs of $comparisonItem",
                  style: const TextStyle(
                    color: GoXeyColors.radicalRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " that are worth RM ${amount.toStringAsFixed(2)}",
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: GoXeyColors.radicalRed,
            ),
            child: const Text("I REGRET NOTHING"),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
