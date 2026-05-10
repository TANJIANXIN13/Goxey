import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../core/theme.dart';

class AvatarStatus extends StatelessWidget {
  final bool isGhostMode;
  final String avatarName;

  const AvatarStatus({
    super.key,
    this.isGhostMode = false,
    this.avatarName = "HIRONO v1.0",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [

            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    isGhostMode ? Colors.white10 : GoXeyColors.radicalRed.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            Opacity(
              opacity: isGhostMode ? 0.3 : 1.0,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: GoXeyColors.deepPurple,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isGhostMode ? Colors.white24 : GoXeyColors.radicalRed,
                    width: 3,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage("https://api.dicebear.com/7.x/bottts/png?seed=GoXey"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            if (isGhostMode)
              Positioned(
                bottom: 10,
                child: Icon(
                  LucideIcons.ghost,
                  color: Colors.white70,
                  size: 32,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          avatarName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: isGhostMode ? Colors.white38 : Colors.white,
              ),
        ),
        const SizedBox(height: 8),
        if (isGhostMode)
          Text(
            "MISSING SAVINGS GOAL",
            style: TextStyle(
              color: GoXeyColors.radicalRed,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSquadMember("https://api.dicebear.com/7.x/avataaars/png?seed=Felix", false),
            _buildSquadMember("https://api.dicebear.com/7.x/avataaars/png?seed=Sarah", true),
            _buildSquadMember("https://api.dicebear.com/7.x/avataaars/png?seed=Jin", false),
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: Icon(LucideIcons.plus, size: 16, color: Colors.white54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSquadMember(String url, bool isGhost) {
    return Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isGhost ? Colors.transparent : GoXeyColors.radicalRed.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Opacity(
        opacity: isGhost ? 0.3 : 1.0,
        child: CircleAvatar(
          backgroundImage: NetworkImage(url),
        ),
      ),
    );
  }
}
