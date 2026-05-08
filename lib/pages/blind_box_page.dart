import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../core/theme.dart';
import '../core/app_state.dart';
import '../widgets/avatar_viewer.dart';

class BlindBoxPage extends StatefulWidget {
  const BlindBoxPage({super.key});

  @override
  State<BlindBoxPage> createState() => _BlindBoxPageState();
}

class _BlindBoxPageState extends State<BlindBoxPage> {
  bool _isOpened = false;
  bool _isRevealed = false;

  void _handleOpen() async {
    setState(() {
      _isOpened = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final appState = Provider.of<AppState>(context, listen: false);
      
      // Define our new IP avatars
      final avatarTemplates = [
        "assets/avatars/avatar_1.jpg",
        "assets/avatars/avatar_2.jpg",
        "assets/avatars/avatar_3.jpg",
        "assets/avatars/avatar_4.jpg",
        "assets/avatars/avatar_5.jpg",
      ];
      
      final randomUrl = (avatarTemplates..shuffle()).first;
      await appState.updateAvatarUrl(randomUrl);
      
      // Need to manual decrement since we used updateAvatarUrl instead of openBlindBox logic for simplicity here
      // But actually AppState has openBlindBox, let's update AppState to use assets too.
      // For now, let's just use the AppState method but update AppState first.
      
      await appState.openBlindBox(); 

      setState(() {
        _isRevealed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Color(0xFF2D0052), Colors.black],
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: GoXeyColors.neonLime.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: GoXeyColors.neonLime.withOpacity(0.5)),
                      ),
                      child: Text(
                        "BOXES LEFT: ${appState.availableBoxes}",
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
                        ElasticIn(
                          child: Icon(Icons.inventory_2, size: 180, color: GoXeyColors.neonLime.withOpacity(0.8)),
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "What's inside for you?",
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: Column(
                    children: [
                      const Text(
                        "NEW AVATAR UNLOCKED",
                        style: TextStyle(
                          color: GoXeyColors.neonLime,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 400,
                        child: AvatarViewer(modelUrl: appState.avatarUrl),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "LEGENDARY EDITION",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
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
                      FadeInUp(
                        delay: const Duration(milliseconds: 300),
                        child: ElevatedButton(
                          onPressed: _isOpened ? null : _handleOpen,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GoXeyColors.neonLime,
                            minimumSize: const Size(double.infinity, 64),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 20,
                            shadowColor: GoXeyColors.neonLime.withOpacity(0.5),
                          ),
                          child: const Text(
                            "TAP TO UNBOX",
                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                        ),
                      )
                    else
                      FadeInUp(
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white24),
                                  minimumSize: const Size(0, 64),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                child: const Text("CLOSE", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (appState.availableBoxes > 0)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isOpened = false;
                                      _isRevealed = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: GoXeyColors.neonLime,
                                    minimumSize: const Size(0, 64),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  child: const Text("OPEN ANOTHER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                ),
                              ),
                          ],
                        ),
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
