import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../core/theme.dart';
import '../core/app_state.dart';
import '../core/pocket_provider.dart';
import '../widgets/avatar_viewer.dart';
import 'avatar_creator_page.dart';

class _CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class BlindBoxPage extends StatefulWidget {
  final String seriesName;
  final String? pocketName;
  const BlindBoxPage({super.key, this.seriesName = "GX Series", this.pocketName});

  @override
  State<BlindBoxPage> createState() => _BlindBoxPageState();
}

class _BlindBoxPageState extends State<BlindBoxPage> {
  bool _isOpened = false;
  bool _isRevealed = false;
  bool _isHidden = false;
  bool _isCustomizing = false;
  String _revealedAvatarUrl = "assets/avatars/goxey_placeholder.png";
  int _customIndex = 0;

  final List<String> _dimooCustomPool = [
    "assets/avatars/dimoo/custom/dimoo_hidden_1.jpg",
    "assets/avatars/dimoo/custom/dimoo_hidden_2.jpg",
    "assets/avatars/dimoo/custom/dimoo_hidden_3.jpg",
    "assets/avatars/dimoo/custom/dimoo_hidden_4.jpg",
    "assets/avatars/dimoo/custom/dimoo_hidden_5.jpg",
    "assets/avatars/dimoo/custom/dimoo_hidden_6.jpg",
    "assets/avatars/dimoo/custom/dimoo_hidden_7.jpg",
    "assets/avatars/dimoo/custom/dimoo_hidden_8.jpg",
    "assets/avatars/dimoo/custom/dimoo_hidden_9.jpg",
    "assets/avatars/dimoo/custom/dimoo_hidden_10.jpg",
  ];

  final List<String> _gxCustomPool = [
    "assets/avatars/goxey/custom/gx_hidden1.png",
    "assets/avatars/goxey/custom/gx_hidden2.png",
    "assets/avatars/goxey/custom/gx_hidden3.png",
    "assets/avatars/goxey/custom/gx_hidden4.png",
  ];

  void _handleOpen() async {
    setState(() => _isOpened = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      final appState = Provider.of<AppState>(context, listen: false);
      
      final pocketProvider = Provider.of<PocketProvider>(context, listen: false);
      int pullCount = pocketProvider.getPullCount(widget.seriesName);
      

      if (pullCount < 3) {
        _isHidden = false;
      } else {

        _isHidden = (DateTime.now().millisecond % 5 == 0); 
      }
      
      Map<String, List<String>> pools = {
        "Dimoo": [
          "assets/avatars/dimoo/dimoo_new_1.png", 
          "assets/avatars/dimoo/dimoo_new_2.png", 
          "assets/avatars/dimoo/dimoo_new_3.png", 
          "assets/avatars/dimoo/dimoo_new_4.png", 
        ],
        "GX Series": [
          "assets/avatars/goxey/gx1.png",
          "assets/avatars/goxey/gx2.png",
          "assets/avatars/goxey/gx3.png",
          "assets/avatars/goxey/gx4.png",
          "assets/avatars/goxey/gx5.png",
          "assets/avatars/goxey/gx6.png",
        ],
        "Molly": ["assets/avatars/molly/molly1.webp", "assets/avatars/molly/molly2.webp", "assets/avatars/molly/molly3.webp"],
        "Crybaby": ["assets/avatars/crybaby/crybaby1.webp", "assets/avatars/crybaby/crybaby2.webp"],
      };

      if (_isHidden && (widget.seriesName == "Dimoo" || widget.seriesName == "GX Series")) {
        _revealedAvatarUrl = widget.seriesName == "Dimoo" 
            ? "assets/avatars/dimoo/dimoo_hidden.png" 
            : "assets/avatars/goxey/gx_hidden.png";
      } else {
        List<String> pool = pools[widget.seriesName] ?? pools["GX Series"]!;
        _revealedAvatarUrl = (List.from(pool)..shuffle()).first;
      }

      await appState.openBlindBox(); 
      
      Provider.of<PocketProvider>(context, listen: false).recordBlindBoxOpen(
        widget.seriesName, 
        _revealedAvatarUrl,
      );
      setState(() => _isRevealed = true);
    }
  }

  void _handleConfirmCustom() {
    final pool = (widget.seriesName == "Dimoo" ? _dimooCustomPool : _gxCustomPool);
    setState(() {
      _revealedAvatarUrl = pool[_customIndex];
      _isCustomizing = false;
    });
    Provider.of<PocketProvider>(context, listen: false).recordBlindBoxOpen(
      widget.seriesName, 
      _revealedAvatarUrl,
      isUpdate: true,
    );
  }

  void _showShareSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A20),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
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
            const SizedBox(height: 24),
            const Text(
              "SHARE YOUR CATCH",
              style: TextStyle(
                color: GoXeyColors.neonLime,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareOption(
                    "IG Story",
                    LucideIcons.camera,
                    const Color(0xFFE1306C),
                  ),
                  const SizedBox(width: 20),
                  _buildShareOption(
                    "WhatsApp",
                    LucideIcons.message_circle,
                    const Color(0xFF25D366),
                  ),
                  const SizedBox(width: 20),
                  _buildShareOption(
                    "Telegram",
                    LucideIcons.send,
                    const Color(0xFF0088CC),
                  ),
                  const SizedBox(width: 20),
                  _buildShareOption(
                    "Copy Link",
                    LucideIcons.link,
                    Colors.white54,
                    onTap: () {
                      Clipboard.setData(const ClipboardData(text: "https://goxey.app/share/rare_catch_123"));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Link copied to clipboard!"),
                          backgroundColor: GoXeyColors.neonLime,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Maybe later", style: TextStyle(color: Colors.white38)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(String label, IconData icon, Color color, {VoidCallback? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap ?? () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Sharing to $label..."),
                backgroundColor: color,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.5), width: 2),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: _isHidden 
              ? [const Color(0xFFFFD700).withOpacity(0.3), Colors.black]
              : [const Color(0xFF2D0052), Colors.black],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: _isCustomizing ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white54),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Text(
                                widget.seriesName.toUpperCase(),
                                style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Text(
                                  "BOXES: ${appState.availableBoxes}",
                                  style: const TextStyle(color: GoXeyColors.neonLime, fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            if (_isRevealed)
                              FadeInDown(
                                duration: const Duration(milliseconds: 800),
                                child: Text(
                                  _isHidden ? "HIDDEN EDITION" : "NORMAL EDITION",
                                  style: TextStyle(
                                    color: _isHidden ? const Color(0xFFFFD700) : Colors.white38, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 12, 
                                    letterSpacing: 2
                                  ),
                                ),
                              )
                            else
                              const Text(
                                "NORMAL EDITION",
                                style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2),
                              ),
                            const SizedBox(height: 30),
                            if (!_isRevealed)
                              SizedBox(
                                height: 400,
                                child: Center(
                                  child: _isOpened 
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          const CircularProgressIndicator(color: GoXeyColors.neonLime),
                                          Lottie.network(
                                            'https://assets10.lottiefiles.com/packages/lf20_6wutsrox.json',
                                            height: 300,
                                          ),
                                        ],
                                      )
                                    : Image.asset(
                                        widget.seriesName == "GX Series" 
                                            ? 'assets/series/Goxey.jpg'
                                            : 'assets/series/${widget.seriesName.toLowerCase().replaceAll(' ', '_')}.jpg',
                                        height: 300,
                                        errorBuilder: (context, error, stackTrace) => Icon(Icons.inventory_2, size: 200, color: Colors.white10),
                                      ),
                                ),
                              )
                            else
                              Column(
                                children: [
                                  if (_isCustomizing)
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 400,
                                          child: ScrollConfiguration(
                                            behavior: _CustomScrollBehavior(),
                                            child: PageView.builder(
                                              controller: PageController(viewportFraction: 0.85, initialPage: 1000), 
                                              physics: const AlwaysScrollableScrollPhysics(),
                                              onPageChanged: (idx) => setState(() => _customIndex = idx % (widget.seriesName == "Dimoo" ? 10 : 4)),
                                              itemBuilder: (context, index) {
                                                final realIdx = index % (widget.seriesName == "Dimoo" ? 10 : 4);
                                                return AnimatedScale(
                                                  scale: _customIndex == realIdx ? 1.0 : 0.8,
                                                  duration: const Duration(milliseconds: 300),
                                                  child: AvatarViewer(
                                                    modelUrl: widget.seriesName == "Dimoo" 
                                                      ? _dimooCustomPool[realIdx]
                                                      : _gxCustomPool[realIdx],
                                                    showBackground: false,
                                                    height: 400,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(widget.seriesName == "Dimoo" ? 10 : 4, (index) => Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 4),
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _customIndex == index ? GoXeyColors.neonLime : Colors.white24,
                                            ),
                                          )),
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          "Swipe to Change Design",
                                          style: TextStyle(color: GoXeyColors.neonLime, fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 400,
                                          child: AvatarViewer(
                                            modelUrl: _revealedAvatarUrl,
                                            showBackground: false,
                                            height: 400,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          _isHidden ? "CONGRATULATIONS!" : "Sweet Catch!",
                                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: [
                              if (!_isRevealed)
                                ElevatedButton(
                                  onPressed: _isOpened ? null : _handleOpen,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: GoXeyColors.neonLime,
                                    minimumSize: const Size(double.infinity, 64),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  child: const Text("TAP TO UNBOX", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
                                )
                              else
                                Column(
                                  children: [
                                    if (_isHidden && (widget.seriesName == "Dimoo" || widget.seriesName == "GX Series") && !_isCustomizing) ...[
                                      ElevatedButton(
                                        onPressed: () => setState(() => _isCustomizing = true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white10,
                                          side: const BorderSide(color: GoXeyColors.neonLime),
                                          minimumSize: const Size(double.infinity, 56),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.palette_outlined, color: GoXeyColors.neonLime),
                                            SizedBox(width: 12),
                                            Text("CUSTOMIZE STYLE", style: TextStyle(color: GoXeyColors.neonLime, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                    if (_isCustomizing)
                                      ElevatedButton(
                                        onPressed: _handleConfirmCustom,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: GoXeyColors.neonLime,
                                          minimumSize: const Size(double.infinity, 64),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        ),
                                        child: const Text("CONFIRM SELECTION", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                      )
                                    else
                                      Column(
                                        children: [
                                          if (_isHidden) ...[
                                            ElevatedButton(
                                              onPressed: _showShareSheet,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                minimumSize: const Size(double.infinity, 56),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              ),
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.share_outlined),
                                                  SizedBox(width: 12),
                                                  Text("SHARE YOUR CATCH", style: TextStyle(fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                          ],
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    side: const BorderSide(color: Colors.white24),
                                                    minimumSize: const Size(0, 64),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  ),
                                                  child: const Text("SAVE & CLOSE", style: TextStyle(color: Colors.white)),
                                                ),
                                              ),
                                              if (appState.availableBoxes > 0) ...[
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() { 
                                                        _isOpened = false; 
                                                        _isRevealed = false; 
                                                        _isHidden = false; 
                                                        _isCustomizing = false;
                                                        _revealedAvatarUrl = "assets/avatars/goxey_placeholder.png";
                                                      });
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: GoXeyColors.neonLime,
                                                      minimumSize: const Size(0, 64),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    ),
                                                    child: const Text("NEXT BOX", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
