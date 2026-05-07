import 'package:flutter/material.dart';
import '../widgets/avatar_viewer.dart';
import '../core/theme.dart';
import 'package:animate_do/animate_do.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          FadeInDown(
            child: const AvatarViewer(),
          ),
          const SizedBox(height: 24),
          const Text(
            "USER",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            "Premium Collector • Level 12",
            style: TextStyle(fontSize: 14, color: GoXeyColors.neonLime),
          ),
          const SizedBox(height: 40),
          _buildProfileOption(Icons.account_balance_wallet_outlined, "Banking Details"),
          _buildProfileOption(Icons.security, "Security & Privacy"),
          _buildProfileOption(Icons.card_giftcard, "Blind Box Collection"),
          _buildProfileOption(Icons.people_outline, "Squad Settings"),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () {},
            child: const Text("Logout", style: TextStyle(color: GoXeyColors.radicalRed)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
        ],
      ),
    );
  }
}
