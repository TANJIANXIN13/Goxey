import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/pocket_provider.dart';
import '../core/app_state.dart';
import '../core/theme.dart';
import 'package:animate_do/animate_do.dart';

class ShowcasePage extends StatefulWidget {
  final Pocket pocket;
  const ShowcasePage({super.key, required this.pocket});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _allMembersBaseData = [
    {
      "name": "Me",
      "avatar": "assets/avatars/avatar_3.jpg",
      "ownedCollections": {},
    },
    {
      "name": "Liam",
      "avatar": "assets/avatars/avatar_2.jpg",
      "ownedCollections": {
        "DIMOO": ["dimoo_new_2.png"],
        "CRYBABY SERIES": ["crybaby3.webp", "crybaby4.webp"],
        "SKULLPANDA": ["skullpanda1.webp"],
        "TWINKLE TWINKLE": ["twinkle twinkle 2.webp", "twinkle twinkle 6.webp"],
        "MOLLY": ["molly2.webp"],
        "GX SERIES": ["gx3.png"],
      },
    },
    {
      "name": "Tom",
      "avatar": "assets/avatars/avatar_5.jpg",
      "ownedCollections": {
        "DIMOO": ["dimoo_new_4.png", "dimoo_hidden.png"],
        "CRYBABY SERIES": ["crybaby7.webp", "crybaby8.webp", "crybaby9.webp"],
        "SKULLPANDA": ["skullpanda7.webp", "skullpanda8.webp"],
        "TWINKLE TWINKLE": ["twinkle twinkle 5.webp", "twinkle twinkle 8.webp"],
        "MOLLY": ["molly3.webp", "molly4.webp"],
        "GX SERIES": ["gx4.png"],
      },
    },
    {
      "name": "Ethan",
      "avatar": "assets/avatars/avatar_4.jpg",
      "ownedCollections": {
        "DIMOO": ["dimoo_new_1.png"],
        "CRYBABY SERIES": ["crybaby1.webp"],
        "SKULLPANDA": ["skullpanda3.webp"],
        "TWINKLE TWINKLE": ["twinkle twinkle 7.webp"],
        "MOLLY": ["molly1.webp"],
        "GX SERIES": ["gx5.png"],
      },
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "SQUAD HUB",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: GoXeyColors.neonLime,
          indicatorWeight: 3,
          labelColor: GoXeyColors.neonLime,
          unselectedLabelColor: Colors.white38,
          tabs: const [
            Tab(text: "UPDATES"),
            Tab(text: "COLLECTION"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpdatesSection(appState),
          _buildCollectionSection(appState),
        ],
      ),
    );
  }

  Widget _buildUpdatesSection(AppState appState) {
    return Consumer<PocketProvider>(
      builder: (context, pocketProvider, child) {
        final currentPocket = pocketProvider.pockets.firstWhere(
          (p) => p.name == widget.pocket.name,
          orElse: () => widget.pocket,
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
                    ? (appState.hasCreatedAvatar ? appState.avatarUrl : "assets/avatars/goxey_placeholder.png") 
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
    );
  }

  Widget _buildCollectionSection(AppState appState) {
    return Consumer<PocketProvider>(
      builder: (context, pocketProvider, child) {
        final List<String> activeMemberNames = ["Me", ...widget.pocket.members];
        
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          itemCount: activeMemberNames.length,
          itemBuilder: (context, index) {
            final name = activeMemberNames[index];
            final baseData = _allMembersBaseData.firstWhere((m) => m['name'] == name, orElse: () => _allMembersBaseData[0]);
            
            final Map<String, List<String>> collections = name == "Me" 
                ? pocketProvider.userOwnedCollections 
                : Map<String, List<String>>.from(baseData['ownedCollections'] ?? {});

            final avatar = name == "Me" 
                ? (appState.hasCreatedAvatar ? appState.avatarUrl : "assets/avatars/goxey_placeholder.png") 
                : baseData['avatar'];

            return FadeInLeft(
              delay: Duration(milliseconds: index * 100),
              child: _buildMemberCollectionCard(name, avatar, collections),
            );
          },
        );
      },
    );
  }

  Widget _buildMemberCollectionCard(String name, String avatar, Map<String, List<String>> collections) {
    final List<Map<String, String>> allFigurines = [];
    collections.forEach((series, files) {
      String folder = "";
      if (series.contains("DIMOO")) folder = "dimoo";
      else if (series.contains("TWINKLE")) folder = "twinkle";
      else if (series.contains("SKULLPANDA")) folder = "skullpanda";
      else if (series.contains("CRYBABY")) folder = "crybaby";
      else if (series.contains("MOLLY")) folder = "molly";
      else if (series.contains("GX")) folder = "goxey";

      for (var file in files) {
        allFigurines.add({
          "path": folder == "goxey" ? "assets/avatars/goxey/$file" : "assets/avatars/$folder/$file",
          "series": series
        });
      }
    });

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: avatar.startsWith('http')
                      ? NetworkImage(avatar) as ImageProvider
                      : AssetImage(avatar) as ImageProvider,
                  radius: 16,
                  backgroundColor: Colors.white10,
                ),
                const SizedBox(width: 12),
                Text(
                  name == "Me" ? "MY COLLECTION" : "${name.toUpperCase()}'S COLLECTION",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                ),
                const Spacer(),
                Text(
                  "${allFigurines.length} ITEMS",
                  style: const TextStyle(color: GoXeyColors.neonLime, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ],
            ),
          ),
          if (allFigurines.isEmpty)
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 20),
              child: Text("No items collected yet", style: TextStyle(color: Colors.white24, fontSize: 11)),
            )
          else
            SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: allFigurines.length,
                itemBuilder: (context, i) {
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12, bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.03)),
                    ),
                    child: Center(
                      child: Image.asset(allFigurines[i]['path']!, height: 60),
                    ),
                  );
                },
              ),
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
            backgroundImage: avatarPath.startsWith('http')
                ? NetworkImage(avatarPath) as ImageProvider
                : AssetImage(avatarPath) as ImageProvider,
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
