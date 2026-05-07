import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/app_state.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/glass_container.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
    final transactions = [
      {"name": "Starbucks Coffee", "category": "Food & Drink", "amount": "-RM 18.50", "icon": Icons.local_cafe, "color": Colors.greenAccent},
      {"name": "Steam Purchase", "category": "Gaming", "amount": "-RM 120.00", "icon": Icons.games, "color": Colors.cyanAccent},
      {"name": "Grab Ride", "category": "Transport", "amount": "-RM 15.00", "icon": Icons.directions_car, "color": Colors.yellowAccent},
      {"name": "Monthly Salary", "category": "Income", "amount": "+RM 5,500.00", "icon": Icons.account_balance_wallet, "color": Colors.pinkAccent},
      {"name": "Uniqlo", "category": "Shopping", "amount": "-RM 89.00", "icon": Icons.shopping_bag, "color": Colors.orangeAccent},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return FadeInUp(
          delay: Duration(milliseconds: 100 * index),
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
                  child: Icon(tx["icon"] as IconData, color: tx["color"] as Color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tx["name"] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(tx["category"] as String, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
                Text(
                  tx["amount"] as String,
                  style: TextStyle(
                    color: (tx["amount"] as String).startsWith("+") ? Colors.greenAccent : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
      // Smooth curves
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

    // Draw dots
    final dotPaint = Paint()..color = Colors.white;
    for (var p in points) {
      canvas.drawCircle(p, 4, dotPaint);
      canvas.drawCircle(p, 6, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
