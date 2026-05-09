import 'package:flutter/material.dart';
import '../core/theme.dart';

class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Squad Showcase", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildFeedItem(
            name: "Liam",
            avatarPath: "assets/avatars/avatar_2.jpg",
            time: "2 hours ago",
            content: "Deposited RM150 into the Langkawi Trip pocket! 🏖️ We are getting closer!",
            isBoxUpdate: false,
          ),
          _buildFeedItem(
            name: "Chloe",
            avatarPath: "assets/avatars/avatar_5.jpg",
            time: "5 hours ago",
            content: "Just opened a DIMOO box and got the DIMOO series! 🌟",
            isBoxUpdate: true,
            boxImage: "assets/avatars/dimoo/dimoo_new_1.png",
          ),
          _buildFeedItem(
            name: "Me",
            avatarPath: "assets/avatars/avatar_3.jpg",
            time: "Yesterday",
            content: "Reached my RM500 milestone for the week. Let's go team!",
            isBoxUpdate: false,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedItem({
    required String name,
    required String avatarPath,
    required String time,
    required String content,
    required bool isBoxUpdate,
    String? boxImage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(avatarPath),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
              const Spacer(),
              Icon(isBoxUpdate ? Icons.card_giftcard : Icons.attach_money, color: isBoxUpdate ? GoXeyColors.radicalRed : GoXeyColors.neonLime, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(content, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4)),
          if (isBoxUpdate && boxImage != null) ...[
            const SizedBox(height: 16),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(boxImage, height: 110, width: 110, fit: BoxFit.cover),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
