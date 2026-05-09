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
  const SquadDetailPage({super.key});

  @override
  State<SquadDetailPage> createState() => _SquadDetailPageState();
}

class _SquadDetailPageState extends State<SquadDetailPage> {
  int _currentCollectionIndex = 0;

  final List<Map<String, dynamic>> _squadMembers = [
    {
      "name": "Me",
      "avatar": "assets/avatars/avatar_3.jpg",
      "isMe": true,
      "status": "ACTIVE",
      "ownedCollections": {
        "DIMOO": ["dimoo_new_1.png", "dimoo_new_3.png"],
        "CRYBABY SERIES": ["crybaby1.webp", "crybaby2.webp", "crybaby5.webp"],
        "SKULLPANDA": ["skullpanda2.webp", "skullpanda5.webp"],
        "TWINKLE TWINKLE": ["twinkle twinkle 1.webp", "twinkle twinkle 4.webp"],
      },
    },
    {
      "name": "Liam",
      "avatar": "assets/avatars/avatar_2.jpg",
      "isMe": false,
      "status": "ACTIVE",
      "ownedCollections": {
        "DIMOO": ["dimoo_new_2.png"],
        "CRYBABY SERIES": ["crybaby3.webp", "crybaby4.webp"],
        "SKULLPANDA": ["skullpanda1.webp"],
        "TWINKLE TWINKLE": ["twinkle twinkle 2.webp", "twinkle twinkle 6.webp"],
      },
    },
    {
      "name": "Chloe",
      "avatar": "assets/avatars/avatar_5.jpg",
      "isMe": false,
      "status": "ACTIVE",
      "ownedCollections": {
        "DIMOO": [
          "dimoo_new_4.png",
          "dimoo_hidden.png",
        ], // Hidden Edition as requested
        "CRYBABY SERIES": ["crybaby7.webp", "crybaby8.webp", "crybaby9.webp"],
        "SKULLPANDA": ["skullpanda7.webp", "skullpanda8.webp"],
        "TWINKLE TWINKLE": ["twinkle twinkle 5.webp", "twinkle twinkle 8.webp"],
      },
    },
    {
      "name": "Ethan",
      "avatar": "assets/avatars/avatar_4.jpg",
      "isMe": false,
      "status": "GHOST",
      "ownedCollections": {
        "DIMOO": ["dimoo_new_1.png"],
        "CRYBABY SERIES": ["crybaby1.webp"],
        "SKULLPANDA": ["skullpanda3.webp"],
        "TWINKLE TWINKLE": ["twinkle twinkle 7.webp"],
      },
    },
  ];

  final Map<String, String> _seriesStats = {
    "CRYBABY SERIES": "Owned Items",
    "SKULLPANDA": "Owned Items",
    "DIMOO": "Owned Items",
    "TWINKLE TWINKLE": "Owned Items",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GoXeyColors.blackRussian,
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              "SQUAD: LANGKAWI TRIP FUND 🏖️",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_none, size: 24),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.sticky_note_2_outlined, size: 24),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz, size: 24),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildProgressSection(),
            const SizedBox(height: 30),
            _buildSquadSection(),
            const SizedBox(height: 30),
            _buildCollectionSection(context),
            const SizedBox(height: 40),
            _buildBottomButtons(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMainButton(
            "Showcase to Squad",
            isPrimary: false,
            onTap: () => _showShowcaseDialog(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMainButton(
            "Redeem New Box",
            isPrimary: true,
            onTap: () => _redeemNewBox(context),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.white54),
                children: [
                  TextSpan(text: "TARGET: "),
                  TextSpan(
                    text: "RM5000",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: " | SAVED: "),
                  TextSpan(
                    text: "RM2150",
                    style: TextStyle(
                      color: GoXeyColors.neonLime,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "SHARED SAVING: 2.5K/5K",
              style: TextStyle(fontSize: 12, color: Colors.white54),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showAddFriendsDialog(context),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: GoXeyColors.neonLime.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: GoXeyColors.neonLime.withOpacity(0.3),
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  size: 14,
                  color: GoXeyColors.neonLime,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Progress bar without avatars
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: 0.43,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        GoXeyColors.radicalRed,
                        GoXeyColors.accentPurple,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: GoXeyColors.radicalRed.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Removed _buildAvatarOnBar method

  Widget _buildSquadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "YOUR SQUAD",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildSquadMember(
          name: "Me",
          subtitle: "Contribution raotive avatar",
          avatarPath: "assets/avatars/avatar_3.jpg",
          status: "ON TRACK",
          statusColor: GoXeyColors.neonLime,
          badge: "GUEST",
          badgeColor: Colors.white24,
        ),
        _buildSquadMember(
          name: "Liam",
          subtitle: "Skullpanda figure as avatar",
          avatarPath: "assets/avatars/avatar_2.jpg",
          amount: "RM800",
          status: "ACTIVE",
          statusColor: GoXeyColors.neonLime,
        ),
        _buildSquadMember(
          name: "Chloe",
          subtitle: "Dimoo figure as avatar",
          avatarPath: "assets/avatars/avatar_5.jpg",
          amount: "RM550",
          status: "ACTIVE",
          statusColor: GoXeyColors.neonLime,
        ),
        _buildSquadMember(
          name: "Ethan",
          subtitle: "Contribution inozin avatar",
          avatarPath: "assets/avatars/avatar_4.jpg",
          amount: "RM450",
          status: "GHOST",
          statusColor: Colors.white24,
          badge: "GHOST",
          badgeColor: Colors.white10,
        ),
      ],
    );
  }

  Widget _buildSquadMember({
    required String name,
    required String subtitle,
    required String avatarPath,
    String? amount,
    required String status,
    required Color statusColor,
    String? badge,
    Color? badgeColor,
  }) {
    bool isGhost = status == "GHOST";

    Widget avatarWidget = SizedBox(
      width: 48,
      height: 48,
      child: AvatarViewer(
        modelUrl: avatarPath,
        height: 48,
        width: 48,
        showBackground: false,
      ),
    );

    if (isGhost) {
      avatarWidget = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: avatarWidget,
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          avatarWidget,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.white38),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  if (amount != null)
                    Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (badge != null) ...[
                const SizedBox(height: 4),
                Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    color: badgeColor ?? Colors.white24,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _currentCollectionIndex == 0
                  ? "YOUR COLLECTION"
                  : "${_squadMembers[_currentCollectionIndex]['name'].toUpperCase()}'S COLLECTION",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 340,
          child: Stack(
            children: [
              // Beautiful Neon L-Spine Rack Background
              Positioned.fill(child: CustomPaint(painter: RackPainter())),

              // Avatar (Bottom Left) - No background
              Positioned(
                left: -15,
                bottom: -20,
                width: MediaQuery.of(context).size.width * 0.45,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Avatar
                    Positioned(
                      bottom: 0,
                      child:
                          _squadMembers[_currentCollectionIndex]['status'] ==
                              "GHOST"
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.matrix([
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0,
                                0,
                                0,
                                1,
                                0,
                              ]),
                              child: AvatarViewer(
                                modelUrl:
                                    _squadMembers[_currentCollectionIndex]['avatar'],
                                height: 240,
                                width: 140,
                                showBackground: false,
                              ),
                            )
                          : AvatarViewer(
                              modelUrl:
                                  _squadMembers[_currentCollectionIndex]['avatar'],
                              height: 240,
                              width: 140,
                              showBackground: false,
                            ),
                    ),
                    // Navigation Arrows
                    Positioned(
                      left: 10,
                      bottom: 100,
                      child: _buildNavArrow(Icons.chevron_left, () {
                        setState(() {
                          _currentCollectionIndex =
                              (_currentCollectionIndex - 1) %
                              _squadMembers.length;
                          if (_currentCollectionIndex < 0)
                            _currentCollectionIndex += _squadMembers.length;
                        });
                      }),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 100,
                      child: _buildNavArrow(Icons.chevron_right, () {
                        setState(() {
                          _currentCollectionIndex =
                              (_currentCollectionIndex + 1) %
                              _squadMembers.length;
                        });
                      }),
                    ),
                  ],
                ),
              ),

              // Shelves (Right Section)
              Positioned(
                right: 0,
                top: 10,
                width: MediaQuery.of(context).size.width * 0.55,
                child: Column(
                  children: [
                    _buildShelf(1, "CRYBABY SERIES"),
                    _buildShelf(2, "SKULLPANDA"),
                    _buildShelf(3, "DIMOO"),
                    _buildShelf(4, "TWINKLE TWINKLE"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildShelf(int number, String title) {
    bool isDimoo = title.contains("DIMOO");
    bool isTwinkle = title.contains("TWINKLE");
    bool isSkullpanda = title.contains("SKULLPANDA");
    bool isCrybaby = title.contains("CRYBABY");

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 64,
      child: Stack(
        children: [
          // Dark Pill Background
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A20).withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "SHELF $number: $title",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                // Figurines
                Expanded(
                  flex: 9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: () {
                      final member = _squadMembers[_currentCollectionIndex];
                      final Map<String, dynamic> ownedCollections =
                          member['ownedCollections'] ?? {};
                      final List<String> ownedItems = List<String>.from(
                        ownedCollections[title] ?? [],
                      );

                      if (ownedItems.isEmpty) {
                        return [const SizedBox()];
                      }

                      return ownedItems.map((fileName) {
                        String folder = "";
                        if (isDimoo)
                          folder = "dimoo";
                        else if (isTwinkle)
                          folder = "twinkle";
                        else if (isSkullpanda)
                          folder = "skullpanda";
                        else if (isCrybaby)
                          folder = "crybaby";

                        return Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Image.asset(
                              "assets/avatars/$folder/$fileName",
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }).toList();
                    }(),
                  ),
                ),

                const SizedBox(width: 8),
              ],
            ),
          ),

          // Neon Glow Bottom Edge
          Positioned(
            bottom: 0,
            left: 15,
            right: 15,
            height: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GoXeyColors.gxCyan.withOpacity(0.8),
                    GoXeyColors.radicalRed.withOpacity(0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: GoXeyColors.gxCyan.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 10, color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildMainButton(
    String text, {
    required bool isPrimary,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary
              ? GoXeyColors.radicalRed
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isPrimary ? Colors.transparent : Colors.white10,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: GoXeyColors.radicalRed.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isPrimary ? Colors.white : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  void _redeemNewBox(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.availableBoxes > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BlindBoxPage(seriesName: "Dimoo"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Save RM 200 more to unlock!"),
          backgroundColor: GoXeyColors.accentPurple,
        ),
      );
    }
  }

  void _showShowcaseDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ShowcasePage()),
    );
  }

  void _showCreatePocketDialog(BuildContext context) {
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    final List<String> selectedMembers = [];
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            "Create Shared Pocket",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Pocket Name (e.g. Bali Trip)",
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: targetController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Target Amount (RM)",
                    prefixText: "RM ",
                    prefixStyle: const TextStyle(color: GoXeyColors.neonLime),
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Invite Members",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...[
                  "Liam – 1029384756 (Maybank)",
                  "Chloe – 5647382910 (CIMB)",
                  "Ethan – 9988776655 (Public Bank)",
                ].map((friend) {
                  final name = friend.split(' ')[0];
                  final isSelected = selectedMembers.contains(name);
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.white10,
                      radius: 16,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white54,
                        size: 16,
                      ),
                    ),
                    title: Text(
                      friend,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    trailing: GestureDetector(
                      onTap: () => setDlgState(() {
                        if (isSelected)
                          selectedMembers.remove(name);
                        else
                          selectedMembers.add(name);
                      }),
                      child: Icon(
                        isSelected
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                        color: isSelected
                            ? GoXeyColors.neonLime
                            : Colors.white38,
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invite link copied!"),
                        backgroundColor: GoXeyColors.neonLime,
                      ),
                    );
                  },
                  icon: const Icon(Icons.share, size: 18, color: Colors.white),
                  label: const Text(
                    "Share Invite Link",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white38),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final target = double.tryParse(targetController.text) ?? 0;
                if (name.isNotEmpty && target > 0) {
                  Provider.of<PocketProvider>(
                    context,
                    listen: false,
                  ).addPocket(name, target, List.from(selectedMembers));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"$name" pocket created! 🚀'),
                      backgroundColor: GoXeyColors.neonLime,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GoXeyColors.radicalRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }

  void _showFriendSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "Select Friends",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText:
                      "Search bank account number of friend/family member",
                  hintStyle: const TextStyle(
                    color: Colors.white24,
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white24),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildFriendItem(context, "Liam", "1029384756 (Maybank)"),
                    _buildFriendItem(context, "Chloe", "5647382910 (CIMB)"),
                    _buildFriendItem(
                      context,
                      "Ethan",
                      "9988776655 (Public Bank)",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Link copied to clipboard!"),
                      backgroundColor: GoXeyColors.neonLime,
                    ),
                  );
                },
                icon: const Icon(Icons.share, size: 18, color: Colors.white),
                label: const Text(
                  "Share Invite Link",
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Done",
              style: TextStyle(color: GoXeyColors.neonLime),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendItem(BuildContext context, String name, String details) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white10,
        child: const Icon(Icons.person, color: Colors.white54),
      ),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        details,
        style: const TextStyle(color: Colors.white38, fontSize: 11),
      ),
      trailing: const Icon(
        Icons.add_circle_outline,
        color: GoXeyColors.neonLime,
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$name added!"),
            backgroundColor: GoXeyColors.gxPurple,
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  void _showAddFriendsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "Add to Squad",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search bank account number of friend/family member",
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white24),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Link copied to clipboard!"),
                    backgroundColor: GoXeyColors.neonLime,
                  ),
                );
              },
              icon: const Icon(Icons.share, size: 18, color: Colors.white),
              label: const Text(
                "Share Invite Link",
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 44),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white38),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Invite sent!"),
                  backgroundColor: GoXeyColors.neonLime,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GoXeyColors.radicalRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Invite"),
          ),
        ],
      ),
    );
  }
}

class RackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [GoXeyColors.gxCyan, GoXeyColors.radicalRed],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          GoXeyColors.gxCyan.withOpacity(0.3),
          GoXeyColors.radicalRed.withOpacity(0.3),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();

    // Shelf geometry constants
    double shelfRightX = size.width;
    double shelfLeftX = size.width * 0.45;

    // Y positions for the shelves (matching _buildShelf spacing)
    List<double> shelfY = [
      10 + 27.0, // Midpoint of shelf 1
      10 + 54 + 20 + 27.0, // Midpoint of shelf 2
      10 + (54 + 20) * 2 + 27.0, // Midpoint of shelf 3
      10 + (54 + 20) * 3 + 27.0, // Midpoint of shelf 4
    ];

    // Draw horizontal shelf lines (connecting to the spine)
    for (int i = 0; i < shelfY.length; i++) {
      path.moveTo(shelfLeftX - 10, shelfY[i]);
      path.lineTo(shelfRightX, shelfY[i]);

      // Vertical end cap
      path.moveTo(shelfRightX, shelfY[i] - 10);
      path.lineTo(shelfRightX, shelfY[i] + 10);
    }

    // Draw the L-shaped vertical spine on the left
    path.moveTo(shelfLeftX - 10, shelfY[0]);
    path.lineTo(shelfLeftX - 10, shelfY[3]);

    // Bottom curve of the spine towards the avatar area
    path.moveTo(shelfLeftX - 10, shelfY[3]);
    path.quadraticBezierTo(
      shelfLeftX - 10,
      shelfY[3] + 40,
      shelfLeftX - 80,
      shelfY[3] + 40,
    );

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
