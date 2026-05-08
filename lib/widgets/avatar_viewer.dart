import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import '../core/app_state.dart';

class AvatarViewer extends StatelessWidget {
  final String? modelUrl;
  final double height;
  final double? width;
  final bool showBackground;
  
  const AvatarViewer({
    super.key, 
    this.modelUrl,
    this.height = 220,
    this.width,
    this.showBackground = true,
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
      decoration: showBackground ? BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white10),
      ) : null,
      child: showBackground 
        ? ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: _buildAvatar(url, isAsset, isGlb),
          )
        : _buildAvatar(url, isAsset, isGlb),
    );
  }

  Widget _buildAvatar(String url, bool isAsset, bool isGlb) {
    Widget avatar;
    if (isAsset) {
      avatar = Image.asset(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.person, size: 100, color: Colors.white24),
        ),
      );
    } else if (isGlb) {
      avatar = ModelViewer(
        src: url,
        alt: "A 3D model of an avatar",
        autoRotate: true,
        cameraControls: true,
        backgroundColor: Colors.transparent,
      );
    } else {
      avatar = Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.person, size: 100, color: Colors.white24),
        ),
      );
    }

    if (!showBackground && isAsset) {
      // Apply a subtle shader mask to fade edges and help 'crop' the avatar people 
      // from their rectangular image backgrounds
      return ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0),
              Colors.black,
              Colors.black,
              Colors.black.withOpacity(0),
            ],
            stops: const [0.0, 0.1, 0.9, 1.0],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstIn,
        child: avatar,
      );
    }

    return avatar;
  }
}
