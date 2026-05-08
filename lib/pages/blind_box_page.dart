import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../core/theme.dart';
import '../core/app_state.dart';
import '../widgets/avatar_viewer.dart';
import 'avatar_creator_page.dart';

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
  String _revealedAvatarUrl = "";

  void _handleOpen() async {
    setState(() => _isOpened = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final appState = Provider.of<AppState>(context, listen: false);
      
      // Hidden Logic (e.g., 20% chance for demo, usually 1/144 in Popmart!)
      _isHidden = (DateTime.now().millisecond % 5 == 0);

      List<String> pool = [];
      if (widget.seriesName == "GoXey Original") {
        pool = ["assets/avatars/avatar_1.jpg", "assets/avatars/avatar_2.jpg", "assets/avatars/avatar_3.jpg", "assets/avatars/avatar_4.jpg", "assets/avatars/avatar_5.jpg"];
      } else {
        pool = ["assets/avatars/avatar_6.jpg", "assets/avatars/avatar_7.jpg", "assets/avatars/avatar_8.jpg", "assets/avatars/avatar_9.jpg", "assets/avatars/avatar_10.jpg"];
      }

      _revealedAvatarUrl = (pool..shuffle()).first;
      
      // If it's normal, we save immediately. If hidden, we wait for customization.
      if (!_isHidden) {
        await appState.updateAvatarUrl(_revealedAvatarUrl);
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
              ? [const Color(0xFFFFD700).withOpacity(0.3), Colors.black] // Golden glow for hidden
              : [const Color(0xFF2D0052), Colors.black],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
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
              const Spacer(),
              
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
                          'https://assets9.lottiefiles.com/packages/lf20_touunsqy.json',
                          repeat: false,
                          height: 300,
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
                      SizedBox(
                        height: 400,
                        child: AvatarViewer(modelUrl: _revealedAvatarUrl),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _isHidden ? "LEGENDARY PULL!" : "Sweet Catch!",
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),
              
              Padding(
                padding: const EdgeInsets.all(40.0),
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
                          if (_isHidden) ...[
                            ElevatedButton.icon(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AvatarCreatorPage()),
                                );
                                if (result != null && mounted) {
                                  await appState.updateAvatarUrl(result as String);
                                  Navigator.pop(context);
                                }
                              },
                              icon: const Icon(Icons.face_retouching_natural, color: Colors.black),
                              label: const Text("CUSTOMIZE FACE SCAN", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFD700),
                                minimumSize: const Size(double.infinity, 64),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                                    onPressed: () => setState(() { _isOpened = false; _isRevealed = false; _isHidden = false; }),
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
            ],
          ),
        ),
      ),
    );
  }
}
