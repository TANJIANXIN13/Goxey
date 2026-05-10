import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/app_state.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;

class HistoryPage extends StatefulWidget {
  final bool isActive;
  const HistoryPage({super.key, this.isActive = false});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _hasShownPopup = false;

  @override
  void didUpdateWidget(covariant HistoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive && !_hasShownPopup) {
      _hasShownPopup = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSpendSummaryDialog(context);
      });
    }
  }

  void _showSpendSummaryDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF090D16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Congratulations, today you paid RM18.50 for a cup of sugary coffee and a misspelled name. ☕",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Expanded(flex: 15, child: Container(color: GoXeyColors.neonLime)),
                    Expanded(flex: 50, child: Container(color: Colors.cyanAccent)),
                    Expanded(flex: 13, child: Container(color: Colors.yellowAccent)),
                    Expanded(flex: 22, child: Container(color: Colors.orangeAccent)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLegendItem(Icons.local_cafe, "Coffee", "15%", GoXeyColors.neonLime),
                _buildLegendItem(Icons.games, "Gaming", "50%", Colors.cyanAccent),
                _buildLegendItem(Icons.directions_car, "Ride", "13%", Colors.yellowAccent),
                _buildLegendItem(Icons.shopping_bag, "Shop", "22%", Colors.orangeAccent),
              ],
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFF9D00F2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9D00F2).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Got it",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, String label, String percentage, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Icon(icon, color: Colors.white38, size: 14),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
        Text(percentage, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isGoxey = appState.isGoxeyMode;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isGoxey ? "Financial Insights" : "Your Rewards",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            isGoxey ? "Real-time spend analysis" : "Points balance: 1,240 GX",
            style: const TextStyle(fontSize: 14, color: Colors.white54),
          ),
          const SizedBox(height: 32),
          if (isGoxey) ...[
            _buildSpendingPieChart(appState),
            const SizedBox(height: 40),
            const Text(
              "Recent Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            _buildTransactionList(),
          ] else ...[
            _buildRewardsUI(),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSpendingPieChart(AppState appState) {
    final transactions = appState.transactions;
    final Map<String, double> categories = {};
    double totalSpend = 0;

    for (var tx in transactions) {
      final amount = tx["amount"] as double;
      if (amount < 0) {
        final category = tx["category"] as String;
        final absAmount = amount.abs();
        categories[category] = (categories[category] ?? 0) + absAmount;
        totalSpend += absAmount;
      }
    }

    if (totalSpend == 0) return const SizedBox();

    final List<Color> sliceColors = [
      GoXeyColors.neonLime,
      Colors.cyanAccent,
      Colors.yellowAccent,
      Colors.orangeAccent,
      GoXeyColors.radicalRed,
    ];

    return FadeInDown(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            const Text(
              "SPENDING SUMMARY",
              style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: CustomPaint(
                    painter: _PieChartPainter(
                      data: categories.values.toList(),
                      colors: sliceColors,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("TOTAL", style: TextStyle(color: Colors.white38, fontSize: 8)),
                          Text(
                            "RM${totalSpend.toStringAsFixed(0)}",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categories.keys.toList().asMap().entries.map((entry) {
                      final i = entry.key;
                      final cat = entry.value;
                      final amount = categories[cat]!;
                      final percentage = (amount / totalSpend * 100).toStringAsFixed(0);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(color: sliceColors[i % sliceColors.length], shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                cat,
                                style: const TextStyle(color: Colors.white70, fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text("$percentage%", style: const TextStyle(color: Colors.white38, fontSize: 11)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final transactions = appState.transactions;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            final amountStr = tx["amount"] >= 0 
                ? "+RM ${tx["amount"].toStringAsFixed(2)}" 
                : "-RM ${tx["amount"].abs().toStringAsFixed(2)}";
            
            return FadeInUp(
              delay: Duration(milliseconds: 50 * index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (tx["color"] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(tx["icon"] as IconData, color: tx["color"] as Color, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx["name"] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text("${tx["category"]} • ${tx["date"]}", style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(
                      amountStr,
                      style: TextStyle(
                        color: tx["amount"] >= 0 ? Colors.greenAccent : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRewardsUI() {
    final rewards = [
      {"title": "RM5 Cashback", "desc": "On your next Grab ride", "points": "500 GX", "icon": Icons.directions_car},
      {"title": "10% Off Starbucks", "desc": "For any venti size drink", "points": "350 GX", "icon": Icons.local_cafe},
      {"title": "Free GX Sticker", "desc": "Limited edition GoXey pack", "points": "100 GX", "icon": Icons.auto_awesome},
      {"title": "RM10 Shopee Voucher", "desc": "Minimum spend RM50", "points": "800 GX", "icon": Icons.shopping_cart},
    ];

    return Column(
      children: rewards.map((r) => FadeInRight(
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: GoXeyColors.gxDarkCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: GoXeyColors.gxPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(r["icon"] as IconData, color: GoXeyColors.gxPurple),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r["title"] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(r["desc"] as String, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(r["points"] as String, style: const TextStyle(color: GoXeyColors.gxCyan, fontWeight: FontWeight.bold)),
                  const Text("Redeem", style: TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<double> data;
  final List<Color> colors;

  _PieChartPainter({required this.data, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final double total = data.fold(0, (sum, item) => sum + item);
    double startAngle = -math.pi / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2 - 6,
    );

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i] / total) * 2 * math.pi;
      paint.color = colors[i % colors.length];
      

      canvas.drawArc(rect, startAngle + 0.05, sweepAngle - 0.1, false, paint);
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
