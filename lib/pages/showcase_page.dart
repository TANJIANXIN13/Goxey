import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/pocket_provider.dart';
import '../core/theme.dart';
import 'package:animate_do/animate_do.dart';

class ShowcasePage extends StatelessWidget {
  final Pocket pocket;
  const ShowcasePage({super.key, required this.pocket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Squad Milestones", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<PocketProvider>(
        builder: (context, pocketProvider, child) {
          final currentPocket = pocketProvider.pockets.firstWhere(
            (p) => p.name == pocket.name,
            orElse: () => pocket,
          );
          
          final activities = currentPocket.activities;

          if (activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history, color: Colors.white24, size: 64),
                  const SizedBox(height: 16),
                  const Text("No milestones yet", style: TextStyle(color: Colors.white38, fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text("Save money or open boxes to see updates!", style: TextStyle(color: Colors.white24, fontSize: 14)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return FadeInUp(
                delay: Duration(milliseconds: index * 50),
                child: _buildFeedItem(
                  name: activity.name,
                  avatarPath: activity.name == "You" || activity.name == "Me"
                      ? "assets/avatars/avatar_3.jpg" 
                      : activity.name == "Liam" 
                          ? "assets/avatars/avatar_2.jpg" 
                          : "assets/avatars/avatar_5.jpg",
                  time: activity.time,
                  content: activity.content,
                  isBoxUpdate: activity.isBoxUpdate,
                  boxImage: activity.boxImage,
                ),
              );
            },
          );
        },
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
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(avatarPath),
            radius: 20,
            backgroundColor: Colors.white10,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(time, style: const TextStyle(color: Colors.white24, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(content, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.4)),
                if (isBoxUpdate && boxImage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.03)),
                    ),
                    child: Center(
                      child: Image.asset(boxImage, height: 100),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
