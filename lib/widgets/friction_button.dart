import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../core/theme.dart';
import 'glass_container.dart';

class FrictionButton extends StatefulWidget {
  final bool isWant;
  final VoidCallback onSuccess;
  final String label;

  const FrictionButton({
    super.key,
    required this.isWant,
    required this.onSuccess,
    required this.label,
  });

  @override
  State<FrictionButton> createState() => _FrictionButtonState();
}

class _FrictionButtonState extends State<FrictionButton> with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  Timer? _timer;
  bool _isPressing = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startPress() {
    if (!widget.isWant) {
      widget.onSuccess();
      return;
    }

    setState(() {
      _isPressing = true;
      _progress = 0.0;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.01; // Approx 5 seconds total (50ms * 100 = 5s)
        if (_progress >= 1.0) {
          _timer?.cancel();
          _isPressing = false;
          _progress = 1.0;
          widget.onSuccess();
        }
      });
    });
  }

  void _stopPress() {
    if (!widget.isWant) return;

    _timer?.cancel();
    setState(() {
      _isPressing = false;
      if (_progress < 1.0) {
        _progress = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isWant ? GoXeyColors.radicalRed : GoXeyColors.neonLime;

    return GestureDetector(
      onLongPressStart: (_) => _startPress(),
      onLongPressEnd: (_) => _stopPress(),
      onTapDown: (_) {
        if (!widget.isWant) {
          widget.onSuccess();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: _isPressing ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.isWant)
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 6.0,
                    percent: _progress,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    progressColor: color,
                    animation: false,
                  ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: widget.isWant ? Colors.white.withOpacity(0.05) : color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(_isPressing ? 0.6 : 0.2),
                        blurRadius: _isPressing ? 20 : 10,
                        spreadRadius: _isPressing ? 5 : 0,
                      ),
                    ],
                    border: Border.all(
                      color: widget.isWant ? color.withOpacity(0.5) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    widget.isWant ? Icons.lock_outline : Icons.check,
                    color: widget.isWant ? color : GoXeyColors.blackRussian,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
          if (_isPressing && widget.isWant)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "HOLD TO REGRET...",
                style: TextStyle(
                  color: color.withOpacity(0.5),
                  fontSize: 8,
                  letterSpacing: 2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
