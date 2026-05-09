import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme.dart';
import 'dart:ui';

class AvatarCreatorPage extends StatefulWidget {
  const AvatarCreatorPage({super.key});

  @override
  State<AvatarCreatorPage> createState() => _AvatarCreatorPageState();
}

class _AvatarCreatorPageState extends State<AvatarCreatorPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;
  bool _showSelection = false;
  
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _selectedAvatarIndex = 0;

  // 10 unique avatars from your collection
  final List<String> _avatarOptions = [
    "assets/avatars/AvatarYX.jpg",
    "assets/avatars/avatar_1.jpg",
    "assets/avatars/avatar_2.jpg",
    "assets/avatars/avatar_3.jpg",
    "assets/avatars/avatar_4.jpg",
    "assets/avatars/avatar_5.jpg",
    "assets/avatars/avatar_6.jpg",
    "assets/avatars/avatar_7.jpg",
    "assets/avatars/avatar_8.jpg",
    "assets/avatars/avatar_9.jpg",
    "assets/avatars/avatar_10.jpg",
  ];

  static const int _infiniteCount = 10000;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = _infiniteCount ~/ 2; 
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        CameraDescription selectedCamera = _cameras!.first;
        for (var camera in _cameras!) {
          if (camera.lensDirection == CameraLensDirection.front) {
            selectedCamera = camera;
            break;
          }
        }

        _controller = CameraController(
          selectedCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _controller!.initialize();
        if (mounted) setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _captureAndProcess() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isProcessing = true);

    // Simulate AI Processing
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _showSelection = true;
        _selectedAvatarIndex = 0; // Default to AvatarYX.jpg
        _currentPage = (_infiniteCount ~/ 2); // Center on the default avatar
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.jumpToPage(_currentPage);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(_showSelection ? "Choose Your Avatar" : "Face Scan", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _showSelection ? _buildSelectionUI() : _buildCameraUI(),
              ),
            ),
            if (!_showSelection) _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraUI() {
    if (_isProcessing) {
      return FadeIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(color: GoXeyColors.neonLime, strokeWidth: 8),
            ),
            const SizedBox(height: 40),
            const Text(
              "GENERATING YOUR IP AVATAR...",
              style: TextStyle(color: GoXeyColors.neonLime, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(height: 12),
            Text("Analyzing facial geometry", style: TextStyle(color: Colors.white.withOpacity(0.5))),
          ],
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator(color: GoXeyColors.neonLime));
    }

    return Container(
      margin: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 400), // Prevent stretching on wide screens
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: GoXeyColors.neonLime.withOpacity(0.3), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: AspectRatio(
          aspectRatio: 1 / _controller!.value.aspectRatio,
          child: CameraPreview(_controller!),
        ),
      ),
    );
  }

  Widget _buildSelectionUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Text(
          "We found your perfect match!",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 450, // Increased height to see the whole avatar
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _infiniteCount,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _selectedAvatarIndex = index % _avatarOptions.length;
                });
              },
              itemBuilder: (context, index) {
                int actualIndex = index % _avatarOptions.length;
                bool isSelected = actualIndex == _selectedAvatarIndex;
                return AnimatedScale(
                  scale: isSelected ? 1.0 : 0.8,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: isSelected ? GoXeyColors.neonLime : Colors.white10,
                        width: isSelected ? 4 : 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(color: GoXeyColors.neonLime.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)
                      ] : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        _avatarOptions[actualIndex],
                        fit: BoxFit.contain, // Changed from cover to contain
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _avatarOptions[_selectedAvatarIndex]),
              style: ElevatedButton.styleFrom(
                backgroundColor: GoXeyColors.neonLime,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("SAVE AVATAR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text("Swipe to see other styles", style: TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  Widget _buildBottomControls() {
    if (_isProcessing) return const SizedBox(height: 100);

    return Container(
      padding: const EdgeInsets.only(bottom: 50, top: 20),
      child: Column(
        children: [
          const Text("Center your face for the scan", style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _captureAndProcess,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: const BoxDecoration(color: GoXeyColors.neonLime, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
