import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../core/theme.dart';

class AvatarViewer extends StatelessWidget {
  final bool isGhostMode;
  final String modelUrl;

  const AvatarViewer({
    super.key,
    this.isGhostMode = false,
    this.modelUrl = "https://modelviewer.dev/shared-assets/models/Astronaut.glb", // Placeholder GoXey IP
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // If in ghost mode, maybe apply a shader or semi-transparent overlay
          Opacity(
            opacity: isGhostMode ? 0.4 : 1.0,
            child: ModelViewer(
              src: modelUrl,
              alt: "GoXey Avatar 3D Model",
              ar: true,
              autoRotate: true,
              cameraControls: true,
              backgroundColor: Colors.transparent,
              disableZoom: true,
            ),
          ),
          if (isGhostMode)
            Positioned(
              top: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: GoXeyColors.radicalRed.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: GoXeyColors.radicalRed, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      "GHOST MODE ACTIVE",
                      style: TextStyle(
                        color: GoXeyColors.radicalRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
