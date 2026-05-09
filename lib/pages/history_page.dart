import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/app_state.dart';
import 'package:animate_do/animate_do.dart';

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
        backgroundColor: const Color(0xFF090D16), // Dark blue that seems like black
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upper part
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
            // Middle part
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
            // 100% Stacked Bar Chart
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
                    Expanded(
                      flex: 15,
                      child: Container(color: GoXeyColors.neonLime),
                    ),
                    Expanded(
                      flex: 50,
                      child: Container(color: Colors.cyanAccent),
                    ),
                    Expanded(
                      flex: 13,
                      child: Container(color: Colors.yellowAccent),
                    ),
                    Expanded(
                      flex: 22,
                      child: Container(color: Colors.orangeAccent),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legends under the bar
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
            // Got It button
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Icon(icon, color: Colors.white38, size: 14),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        Text(
          percentage,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
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
            _buildBeautifiedChart(),
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

  Widget _buildBeautifiedChart() {
    return FadeInDown(
      child: Container(
        height: 240,
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Monthly Spending", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text("RM 4,280.50", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: GoXeyColors.radicalRed.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("+12%", style: TextStyle(color: GoXeyColors.radicalRed, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 100,
              width: double.infinity,
              child: CustomPaint(
                painter: _ChartPainter(),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("MON", style: TextStyle(color: Colors.white38, fontSize: 10)),
                Text("TUE", style: TextStyle(color: Colors.white38, fontSize: 10)),
                Text("WED", style: TextStyle(color: Colors.white38, fontSize: 10)),
                Text("THU", style: TextStyle(color: Colors.white38, fontSize: 10)),
                Text("FRI", style: TextStyle(color: Colors.white38, fontSize: 10)),
                Text("SAT", style: TextStyle(color: Colors.white38, fontSize: 10)),
                Text("SUN", style: TextStyle(color: Colors.white38, fontSize: 10)),
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

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GoXeyColors.radicalRed
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [GoXeyColors.radicalRed.withOpacity(0.3), Colors.transparent],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    final path = Path();
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.5),
      Offset(size.width * 0.3, size.height * 0.8),
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.7, size.height * 0.4),
      Offset(size.width * 0.85, size.height * 0.1),
      Offset(size.width, size.height * 0.3),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p1.dx, p1.dy);
    }

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = Colors.white;
    for (var p in points) {
      canvas.drawCircle(p, 4, dotPaint);
      canvas.drawCircle(p, 6, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
