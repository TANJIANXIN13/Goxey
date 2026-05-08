import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/app_state.dart';
import '../widgets/roast_card.dart';
import '../widgets/friction_button.dart';
import '../widgets/spend_visualizer.dart';
import '../widgets/mode_toggle.dart';
import '../widgets/avatar_viewer.dart';
import '../widgets/glass_container.dart';
import 'history_page.dart';
import 'blind_box_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'me_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  bool _isBalanceVisible = true;

  void _showFunctionalityToast(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$feature feature coming soon!"),
        backgroundColor: GoXeyColors.accentPurple,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _showPocketMoneyDialog() {
    final TextEditingController amountController = TextEditingController();
    final appState = Provider.of<AppState>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Add Pocket Money", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "How much do you want to save today?",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(color: GoXeyColors.neonLime, fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixText: "RM ",
                prefixStyle: const TextStyle(color: GoXeyColors.neonLime, fontSize: 24),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0;
              if (amount > 0 && amount <= appState.totalBalance) {
                appState.transferToPockets(amount);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Transferred RM ${amount.toStringAsFixed(2)} to Pockets!"),
                    backgroundColor: GoXeyColors.neonLime,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid amount or insufficient balance")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GoXeyColors.neonLime,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _triggerQrPaymentFriction() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GlassContainer(
        padding: const EdgeInsets.all(32),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            const Text(
              "QR PAYMENT: WANT DETECTED",
              style: TextStyle(color: GoXeyColors.radicalRed, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            const SizedBox(height: 8),
            const Text(
              "Late night Shopee haul? You already have 3 keyboards.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 32),
            FrictionButton(
              isWant: true,
              label: "CONFIRM RM 400.00",
              onSuccess: () {
                Navigator.pop(context);
                SpendVisualizer.show(context, amount: 400, item: "Maggi", count: 200);
              },
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("I regret my choices", style: TextStyle(color: Colors.white38)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isGoxey = appState.isGoxeyMode;

    // Reset index to Home if switching to Original Mode while on a restricted tab
    if (!isGoxey && _currentIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _currentIndex != 0) {
          setState(() => _currentIndex = 0);
        }
      });
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isGoxey
                ? [const Color(0xFF212427), const Color(0xFF212427)] // Solid #212427
                : [GoXeyColors.gxBgTop, GoXeyColors.gxBgBottom], // GXBank Classic
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(isGoxey),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                    _buildHomeContent(isGoxey, appState),
                    HistoryPage(isActive: _currentIndex == 1),
                    const Center(child: Text("Discover Page", style: TextStyle(color: Colors.white))),
                    const MePage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isGoxey),
    );
  }

  Widget _buildHomeContent(bool isGoxey, AppState appState) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildBalanceSection(isGoxey, appState.totalBalance),
          const SizedBox(height: 24),
          _buildQuickActions(isGoxey),
          const SizedBox(height: 32),
          // Lower section starts here
          IgnorePointer(
            ignoring: !isGoxey,
            child: Column(
              children: [
                _buildAccountsSection(isGoxey, appState.totalBalance, appState.pocketsBalance),
                const SizedBox(height: 24),
                if (isGoxey) ...[
                  _buildAvatarBlindBoxSection(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FadeInUp(child: const RoastCard()),
                  ),
                ] else ...[
                  _buildPromoSection(isGoxey),
                ],
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isGoxey) {
    String title = "Home";
    if (_currentIndex == 1) title = isGoxey ? "History" : "Rewards";
    if (_currentIndex == 2) title = isGoxey ? "Squad" : "Discover";
    if (_currentIndex == 3) title = "Me";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "USER",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                ],
              ),
            ],
          ),
          const Spacer(),
          const ModeToggle(),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white, size: 24),
            onPressed: () => _showFunctionalityToast("Support"),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white, size: 24),
            onPressed: () => _showFunctionalityToast("Notifications"),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(bool isGoxey, double balance) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Total balance",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(width: 8),
              Icon(Icons.verified_user, color: Colors.blue.shade300, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _isBalanceVisible ? "RM${balance.toStringAsFixed(2)}" : "RM *****",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _showFunctionalityToast("Balance Details"),
            child: const Row(
              children: [
                Text(
                  "Balance info",
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
                Icon(Icons.chevron_right, color: Colors.white54, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isGoxey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionCircle(Icons.add, "Add money", isGoxey, () => _showFunctionalityToast("Add Money")),
        _buildActionCircle(Icons.qr_code_scanner, "Scan QR", isGoxey, () => isGoxey ? _triggerQrPaymentFriction() : _showFunctionalityToast("Scan QR")),
        _buildActionCircle(Icons.send, "Send money", isGoxey, () => _showFunctionalityToast("Send Money")),
      ],
    );
  }

  Widget _buildActionCircle(IconData icon, String label, bool isGoxey, VoidCallback onTap) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isGoxey ? const Color(0xFFEE2677) : GoXeyColors.gxPurple,
            shape: BoxShape.circle,
            boxShadow: [
              if (isGoxey)
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 10,
                )
            ],
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 24),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAccountsSection(bool isGoxey, double totalBalance, double pocketsBalance) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your everyday account",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Icon(Icons.credit_card, color: Colors.white54, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildAccountCard("Main account", "RM${totalBalance.toStringAsFixed(2)}", null, isGoxey)),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: isGoxey ? _showPocketMoneyDialog : () => _showFunctionalityToast("Pockets"),
                  child: _buildAccountCard("Pockets", "RM${pocketsBalance.toStringAsFixed(2)}", "Up to 3.55% p.a.", isGoxey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(String title, String balance, String? promo, bool isGoxey) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 180,
      decoration: BoxDecoration(
        color: isGoxey ? null : GoXeyColors.gxDarkCard,
        gradient: isGoxey ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9D00F2), Color(0xFFEE2677)],
        ) : null,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            balance,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (promo != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: GoXeyColors.gxCyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                promo,
                style: const TextStyle(color: GoXeyColors.gxCyan, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          const Spacer(),
          if (title == "Main account")
            const Text(
              "View transactions",
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
        ],
      ),
    );
  }

  int _selectedSeriesIndex = 0;
  late int _currentSeriesPage;
  static const int _infiniteSeriesCount = 10000;

  final List<Map<String, dynamic>> _seriesOptions = [
    {
      "name": "GoXey Original",
      "tag": "IP SERIES 1",
      "color": GoXeyColors.neonLime,
      "poster": "assets/avatars/avatar_1.jpg",
    },
    {
      "name": "Hirono",
      "tag": "MONSTERS' CARNIVAL",
      "color": const Color(0xFF8B4513),
      "poster": "assets/series/hirono.jpg",
    },
    {
      "name": "Molly",
      "tag": "SCENERY ALONG THE WAY",
      "color": const Color(0xFF00BFFF),
      "poster": "assets/series/molly.jpg",
    },
    {
      "name": "Skullpanda",
      "tag": "THE FEAST BEGINS",
      "color": const Color(0xFFE6E6FA),
      "poster": "assets/series/skullpanda.jpg",
    },
    {
      "name": "Crybaby",
      "tag": "CRYING TO THE MOON",
      "color": const Color(0xFFFF69B4),
      "poster": "assets/series/crybaby.jpg",
    },
    {
      "name": "Twinkle Twinkle",
      "tag": "SAVOR THE MOMENT",
      "color": const Color(0xFFFFA500),
      "poster": "assets/series/twinkle.jpg",
    },
    {
      "name": "Dimoo",
      "tag": "THE MISSING DAY",
      "color": const Color(0xFF9ACD32),
      "poster": "assets/series/dimoo.jpg",
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentSeriesPage = _infiniteSeriesCount ~/ 2;
  }

  Widget _buildAvatarBlindBoxSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Series Collection",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "SWIPE SERIES",
                style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.2),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Series Carousel (Infinite Loop)
        SizedBox(
          height: 420,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: PageView.builder(
              controller: PageController(
                viewportFraction: 0.85,
                initialPage: _currentSeriesPage,
              ),
              itemCount: _infiniteSeriesCount,
              onPageChanged: (index) {
                setState(() {
                  _currentSeriesPage = index;
                  _selectedSeriesIndex = index % _seriesOptions.length;
                });
              },
              itemBuilder: (context, index) {
                final actualIndex = index % _seriesOptions.length;
                final series = _seriesOptions[actualIndex];
                bool isSelected = _selectedSeriesIndex == actualIndex;
                bool hasPoster = series.containsKey('poster') && series['name'] != "GoXey Original";
                
                return AnimatedScale(
                  scale: isSelected ? 1.0 : 0.9,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withOpacity(0.05) : Colors.black12,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: isSelected ? series['color'].withOpacity(0.5) : Colors.white10,
                        width: 2,
                      ),
                      image: hasPoster ? DecorationImage(
                        image: AssetImage(series['poster']),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(isSelected ? 0.4 : 0.7),
                          BlendMode.darken,
                        ),
                      ) : null,
                      boxShadow: isSelected ? [
                        BoxShadow(color: series['color'].withOpacity(0.2), blurRadius: 20, spreadRadius: 5)
                      ] : [],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: series['color'].withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  series['tag'],
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                series['name'].toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
                              ),
                              const Spacer(),
                              Hero(
                                tag: 'box_${series['name']}',
                                child: Icon(Icons.inventory_2, size: 120, color: series['color']),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
          const SizedBox(height: 24),
          Consumer<AppState>(
            builder: (context, appState, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Next Box: RM ${(200 - (appState.pocketsBalance % 200)).toStringAsFixed(0)} left",
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      Text(
                        "${(appState.progressToNextBox * 100).toInt()}%",
                        style: const TextStyle(color: GoXeyColors.neonLime, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearPercentIndicator(
                    lineHeight: 8.0,
                    percent: appState.progressToNextBox,
                    backgroundColor: Colors.white10,
                    progressColor: GoXeyColors.neonLime,
                    barRadius: const Radius.circular(4),
                    padding: EdgeInsets.zero,
                    animation: true,
                    animateFromLastPercent: true,
                  ),
                  const SizedBox(height: 24),
                  _buildAvatarAction(
                    appState.availableBoxes > 0 
                      ? "Open ${_seriesOptions[_selectedSeriesIndex]['name']} (${appState.availableBoxes})" 
                      : "Open Series",
                    Icons.card_giftcard,
                    appState.availableBoxes > 0 
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlindBoxPage(
                                seriesName: _seriesOptions[_selectedSeriesIndex]['name'],
                              ),
                            ),
                          );
                        }
                      : () => _showFunctionalityToast("Save RM 200 more to unlock!"),
                    isHighlight: appState.availableBoxes > 0,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarAction(String label, IconData icon, VoidCallback onTap, {bool isHighlight = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlight ? GoXeyColors.neonLime.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isHighlight ? GoXeyColors.neonLime : Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: isHighlight ? GoXeyColors.neonLime : Colors.black, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label, 
                style: TextStyle(
                  color: isHighlight ? GoXeyColors.neonLime : Colors.black, 
                  fontSize: 12, 
                  fontWeight: FontWeight.bold
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoSection(bool isGoxey) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "For you today",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isGoxey ? Colors.white.withOpacity(0.1) : GoXeyColors.gxDarkCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined, color: Colors.greenAccent, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bonus Pockets",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Earn up to 3.55% p.a. interest. No penalty.",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _showFunctionalityToast("Promo"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(100, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text("Explore", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isGoxey) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final isGoxey = appState.isGoxeyMode;
        
        List<BottomNavigationBarItem> navItems = [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: const Icon(Icons.redeem),
            label: isGoxey ? "History" : "Rewards",
          ),
          BottomNavigationBarItem(
            icon: Icon(isGoxey ? Icons.emoji_events_outlined : Icons.widgets_outlined),
            label: isGoxey ? "Squad" : "Discover",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: "Me"),
        ];

        return Theme(
          data: ThemeData(
            canvasColor: isGoxey ? Colors.white.withOpacity(0.05) : const Color(0xFF0F021F),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: isGoxey ? Colors.white : GoXeyColors.gxPurple,
            unselectedItemColor: Colors.white38,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            onTap: (index) {
              if (!isGoxey && index != 0) {
                // Stay on Home in Original Mode
                return;
              }
              setState(() => _currentIndex = index);
            },
            items: navItems,
          ),
        );
      },
    );
  }
}
