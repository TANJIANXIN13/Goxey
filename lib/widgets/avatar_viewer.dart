import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import '../core/app_state.dart';

class AvatarViewer extends StatelessWidget {
  final String? modelUrl;
  final double height;
  final double? width;
  
  const AvatarViewer({
    super.key, 
    this.modelUrl,
    this.height = 220,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final url = modelUrl ?? appState.avatarUrl;

    // Check if the URL is an asset path (GoXey IP avatars) or a 3D model
    bool isAsset = url.startsWith('assets/');
    bool isGlb = url.endsWith('.glb');

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: _buildAvatar(url, isAsset, isGlb),
      ),
    );
  }

  Widget _buildAvatar(String url, bool isAsset, bool isGlb) {
    if (isAsset) {
      return Image.asset(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.person, size: 100, color: Colors.white24),
        ),
      );
    }

    if (isGlb) {
      return ModelViewer(
        src: url,
        alt: "A 3D model of an avatar",
        autoRotate: true,
        cameraControls: true,
        backgroundColor: Colors.transparent,
      );
    }

    return Image.network(
      url,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Icon(Icons.person, size: 100, color: Colors.white24),
      ),
    );
  }
}
