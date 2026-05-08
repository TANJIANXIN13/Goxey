import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../core/theme.dart';
import '../core/app_state.dart';
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
  const BlindBoxPage({super.key, this.seriesName = "GoXey Original"});

  @override
  State<BlindBoxPage> createState() => _BlindBoxPageState();
}

class _BlindBoxPageState extends State<BlindBoxPage> {
  bool _isOpened = false;
  bool _isRevealed = false;
  bool _isHidden = false;
  bool _isCustomizing = false;
  String _revealedAvatarUrl = "";
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

  void _handleOpen() async {
    setState(() => _isOpened = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final appState = Provider.of<AppState>(context, listen: false);
      
      // Hidden Logic: 10% chance for demo (1/10)
      _isHidden = (DateTime.now().millisecond % 10 == 0);

      // Distribute rewards for active demo series
      if (widget.seriesName == "Dimoo" || widget.seriesName == "GoXey Original") {
        if (_isHidden) {
          // Rare pulls for both series
          if (widget.seriesName == "Dimoo") {
            _revealedAvatarUrl = "assets/avatars/dimoo/dimoo_hidden.png";
          } else {
            _revealedAvatarUrl = "assets/avatars/goxey/goxey_hidden.jpg";
          }
        } else {
          Map<String, List<String>> pools = {
            "Dimoo": [
              "assets/avatars/dimoo/dimoo_new_1.png", 
              "assets/avatars/dimoo/dimoo_new_2.png", 
              "assets/avatars/dimoo/dimoo_new_3.png", 
              "assets/avatars/dimoo/dimoo_new_4.png", 
            ],
            "GoXey Original": [
              "assets/avatars/goxey/goxey_1.jpg",
              "assets/avatars/goxey/goxey_2.jpg",
              "assets/avatars/goxey/goxey_3.jpg",
              "assets/avatars/goxey/goxey_4.jpg",
              "assets/avatars/goxey/goxey_5.jpg",
              "assets/avatars/goxey/goxey_6.jpg",
              "assets/avatars/goxey/goxey_7.jpg",
              "assets/avatars/goxey/goxey_8.jpg",
              "assets/avatars/goxey/goxey_9.jpg",
            ],
          };
          List<String> pool = pools[widget.seriesName] ?? pools["Dimoo"]!;
          _revealedAvatarUrl = (pool..shuffle()).first;
        }
      } else {
        _revealedAvatarUrl = ""; // Others are coming soon
      }
      
      await appState.openBlindBox(); 

      setState(() => _isRevealed = true);
    }
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
                        // Top Bar
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
                                  color: GoXeyColors.neonLime.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: GoXeyColors.neonLime.withOpacity(0.5)),
                                ),
                                child: Text(
                                  "BOXES: ${appState.availableBoxes}",
                                  style: const TextStyle(color: GoXeyColors.neonLime, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        const SizedBox(height: 20),
                  
                  if (!_isRevealed) ...[
                    ZoomIn(
                      duration: const Duration(milliseconds: 500),
                      child: Column(
                        children: [
                          if (!_isOpened)
                            Hero(
                              tag: 'box_${widget.seriesName}',
                              child: Icon(Icons.inventory_2, size: 180, color: widget.seriesName == "GoXey Original" ? GoXeyColors.neonLime : GoXeyColors.radicalRed),
                            )
                          else
                            Lottie.network(
                              'https://lottie.host/6168532c-3543-4414-8789-940733835697/xYmR7H5S0I.json',
                              repeat: false,
                              height: 300,
                              errorBuilder: (context, error, stackTrace) => const SizedBox(height: 300, child: Center(child: CircularProgressIndicator(color: GoXeyColors.neonLime))),
                            ),
                          const SizedBox(height: 40),
                          Text(
                            _isOpened ? "OPENING..." : "MYSTERY BOX",
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 4),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: Column(
                        children: [
                          if (_isHidden)
                            Pulse(
                              infinite: true,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD700),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "✨ HIDDEN EDITION ✨",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            )
                          else
                            const Text(
                              "NORMAL EDITION",
                              style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2),
                            ),
                          
                          const SizedBox(height: 30),
                          
                          if (_revealedAvatarUrl.isEmpty)
                            SizedBox(
                              height: 400,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.auto_awesome, size: 80, color: GoXeyColors.neonLime.withOpacity(0.5)),
                                    const SizedBox(height: 24),
                                    const Text(
                                      "REWARD UNDER\nDEVELOPMENT",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: GoXeyColors.neonLime,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Stay tuned for the official launch!",
                                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                                    ),
                                  ],
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
                                            onPageChanged: (idx) => setState(() => _customIndex = idx % 10),
                                            itemBuilder: (context, index) {
                                              final realIdx = index % 10;
                                              return AnimatedScale(
                                                scale: _customIndex == realIdx ? 1.0 : 0.8,
                                                duration: const Duration(milliseconds: 300),
                                                child: AvatarViewer(
                                                  modelUrl: _dimooCustomPool[realIdx],
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
                                        children: List.generate(10, (index) => Container(
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
                                        "Swipe to Change Color",
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
                                        _isHidden ? "LEGENDARY PULL!" : "Sweet Catch!",
                                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],

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
                              if (_isHidden && widget.seriesName == "Dimoo" && !_isCustomizing) ...[
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
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
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
                                        onPressed: () => setState(() { 
                                          _isOpened = false; 
                                          _isRevealed = false; 
                                          _isHidden = false; 
                                          _isCustomizing = false;
                                        }),
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
