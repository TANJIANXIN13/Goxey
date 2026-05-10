
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../core/theme.dart';
import '../core/app_state.dart';
import '../core/pocket_provider.dart';
import '../widgets/avatar_viewer.dart';
import 'blind_box_page.dart';
import 'showcase_page.dart';

class SquadDetailPage extends StatefulWidget {
  final Pocket pocket;
  const SquadDetailPage({super.key, required this.pocket});

  @override
  State<SquadDetailPage> createState() => _SquadDetailPageState();
}

class _SquadDetailPageState extends State<SquadDetailPage> {
  int _currentCollectionIndex = 0;

  final List<Map<String, dynamic>> _squadMembersData = [
    {
      "name": "Me",
      "avatar": "assets/avatars/avatar_3.jpg",
      "description": "Contribution active avatar",
      "isMe": true,
      "status": "ON TRACK",
      "statusColor": GoXeyColors.neonLime,
      "ownedCollections": {
        "DIMOO": ["dimoo_new_1.png", "dimoo_new_3.png"],
        "CRYBABY SERIES": ["crybaby1.webp", "crybaby2.webp", "crybaby5.webp"],
        "SKULLPANDA": ["skullpanda2.webp", "skullpanda5.webp"],
        "TWINKLE TWINKLE": ["twinkle twinkle 1.webp", "twinkle twinkle 4.webp"],
        "MOLLY": ["molly1.webp", "molly5.webp"],
        "GX SERIES": ["gx1.png", "gx2.png"],
      },
    },
    {
      "name": "Liam",
      "avatar": "assets/avatars/avatar_2.jpg",
      "description": "Skullpanda figure as avatar",
      "isMe": false,
      "status": "ACTIVE",
      "statusColor": GoXeyColors.neonLime,
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
      "description": "Dimoo figure as avatar",
      "isMe": false,
      "status": "ACTIVE",
      "statusColor": GoXeyColors.neonLime,
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
      "description": "Contribution inozin avatar",
      "isMe": false,
      "status": "GHOST",
      "statusColor": Colors.white24,
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

  double _getContribution(String memberName, Pocket pocket) {
    if (pocket.name.contains("Langkawi")) {
      if (memberName == "Liam") return 800;
      if (memberName == "Tom") return 550;
      if (memberName == "Ethan") return 450;
      if (memberName == "Me") return (pocket.saved - 1800).clamp(0.0, 9999.0);
    }
    return memberName == "Me" ? pocket.saved : 0;
  }

  @override
  Widget build(BuildContext context) {

    final List<String> activeMemberNames = ["Me", ...widget.pocket.members];

    if (activeMemberNames.isEmpty) {
      return Scaffold(
        backgroundColor: GoXeyColors.blackRussian,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: Text("No members in this squad", style: TextStyle(color: Colors.white24))),
      );
    }

    final pocketProvider = Provider.of<PocketProvider>(context);
    final currentMemberName = activeMemberNames[_currentCollectionIndex % activeMemberNames.length];
    final Map<String, dynamic> baseMember = _squadMembersData.firstWhere(
      (m) => m['name'] == currentMemberName, 
      orElse: () => _squadMembersData[0]
    );
    

    final currentMember = currentMemberName == "Me" 
        ? {...baseMember, 'ownedCollections': pocketProvider.userOwnedCollections}
        : baseMember;
    final bool isGhost = currentMember['status'] == "GHOST";
    final bool isMe = currentMemberName == "Me";

    return Scaffold(
      backgroundColor: GoXeyColors.blackRussian,
      appBar: AppBar(
        title: Text(
          widget.pocket.name.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: "TARGET: ", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                            TextSpan(text: "RM${widget.pocket.target.toInt()} ", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            const TextSpan(text: "| SAVED: ", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                            TextSpan(text: "RM${widget.pocket.saved.toInt()}", style: const TextStyle(color: GoXeyColors.neonLime, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(text: "SHARED SAVING: ", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                            TextSpan(text: "2.5K/5K", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (widget.pocket.saved / widget.pocket.target).clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [GoXeyColors.radicalRed, GoXeyColors.accentPurple]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),


            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "YOUR SQUAD",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1),
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeMemberNames.length,
              itemBuilder: (context, index) {
                final name = activeMemberNames[index];
                final member = _squadMembersData.firstWhere((m) => m['name'] == name, orElse: () => _squadMembersData[0]);
                final contribution = _getContribution(name, widget.pocket);
                return _buildMemberTile(member, contribution);
              },
            ),

            const SizedBox(height: 30),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                isMe ? "YOUR COLLECTION" : "${currentMemberName.toUpperCase()}'S COLLECTION",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1),
              ),
            ),

            const SizedBox(height: 20),


            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      ColorFiltered(
                        colorFilter: isGhost 
                          ? const ColorFilter.matrix([
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0,      0,      0,      1, 0,
                            ])
                          : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                        child: AvatarViewer(
                          modelUrl: currentMember['avatar'],
                          height: 280,
                          width: 160,
                          showBackground: false,
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ShowcasePage(pocket: widget.pocket)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GoXeyColors.accentPurple.withOpacity(0.2),
                            side: const BorderSide(color: GoXeyColors.accentPurple, width: 1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size(double.infinity, 40),
                          ),
                          child: const Text(
                            "Squad Milestones",
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildNavArrow(Icons.chevron_left, () {
                            setState(() {
                              if (_currentCollectionIndex > 0) _currentCollectionIndex--;
                            });
                          }),
                          const SizedBox(width: 15),
                          Text(
                            currentMemberName.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                          ),
                          const SizedBox(width: 15),
                          _buildNavArrow(Icons.chevron_right, () {
                            setState(() {
                              _currentCollectionIndex++;
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                ),


                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        _buildShelf(1, "CRYBABY SERIES", currentMember),
                        _buildShelf(2, "SKULLPANDA", currentMember),
                        _buildShelf(3, "DIMOO", currentMember),
                        _buildShelf(4, "TWINKLE TWINKLE", currentMember),
                        _buildShelf(5, "MOLLY", currentMember),
                        _buildShelf(6, "GX SERIES", currentMember),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(Map<String, dynamic> member, double contribution) {
    bool isGhost = member['status'] == "GHOST";
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ColorFiltered(
            colorFilter: isGhost 
              ? const ColorFilter.matrix([
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0,      0,      0,      1, 0,
                ])
              : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(member['avatar']),
              backgroundColor: Colors.white10,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (contribution > 0)
                Text("RM${contribution.toInt()}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: member['statusColor'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  member['status'],
                  style: TextStyle(color: member['statusColor'], fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (isGhost) ...[
            const SizedBox(width: 8),
            const Text("GUEST", style: TextStyle(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.bold)),
          ]
        ],
      ),
    );
  }

  Widget _buildNavArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white54, size: 20),
    );
  }

  Widget _buildShelf(int number, String title, Map<String, dynamic> member) {
    bool isGoxey = title.contains("GX");
    final List<String> ownedItems = List<String>.from(member['ownedCollections']?[title] ?? []);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 60,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A20).withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "SHELF $number: $title",
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 10,
            bottom: 5,
            child: Row(
              children: ownedItems.map((fileName) {
                String folder = "";
                if (title.contains("DIMOO")) folder = "dimoo";
                else if (title.contains("TWINKLE")) folder = "twinkle";
                else if (title.contains("SKULLPANDA")) folder = "skullpanda";
                else if (title.contains("CRYBABY")) folder = "crybaby";
                else if (title.contains("MOLLY")) folder = "molly";
                else if (title.contains("GX")) folder = "goxey";

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Image.asset(
                    folder == "goxey" 
                    ? "assets/avatars/goxey/$fileName" 
                    : "assets/avatars/$folder/$fileName",
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, isGoxey ? GoXeyColors.neonLime : GoXeyColors.radicalRed, Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
