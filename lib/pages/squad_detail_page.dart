import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/app_state.dart';
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
    {"name": "Me", "avatar": "assets/avatars/avatar_3.jpg", "isMe": true, "status": "ACTIVE"},
    {"name": "Liam", "avatar": "assets/avatars/avatar_2.jpg", "isMe": false, "status": "ACTIVE"},
    {"name": "Chloe", "avatar": "assets/avatars/avatar_5.jpg", "isMe": false, "status": "ACTIVE"},
    {"name": "Ethan", "avatar": "assets/avatars/avatar_4.jpg", "isMe": false, "status": "GHOST"},
  ];

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
          ],
        ),
      ),
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
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " | SAVED: "),
                  TextSpan(
                    text: "RM2150",
                    style: TextStyle(color: GoXeyColors.neonLime, fontWeight: FontWeight.bold),
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
                  border: Border.all(color: GoXeyColors.neonLime.withOpacity(0.3)),
                ),
                child: const Icon(Icons.add, size: 14, color: GoXeyColors.neonLime),
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
                      colors: [GoXeyColors.radicalRed, GoXeyColors.accentPurple],
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
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0,      0,      0,      1, 0,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                  style: TextStyle(fontSize: 10, color: badgeColor ?? Colors.white24),
                ),
              ]
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
              _currentCollectionIndex == 0 ? "YOUR COLLECTION" : "${_squadMembers[_currentCollectionIndex]['name'].toUpperCase()}'S COLLECTION",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 340,
          child: Stack(
            children: [
              // Beautiful Neon S-Curve Rack Background
              Positioned.fill(
                child: CustomPaint(
                  painter: RackPainter(),
                ),
              ),
              // Avatar and Stage (Left Section)
              Positioned(
                left: 0,
                top: 25,
                width: MediaQuery.of(context).size.width * 0.4,
                height: 250,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    // Avatar Stage
                    Container(
                      width: 140,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C35),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          )
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Neon line
                          Positioned(
                            top: 6, // creates a top surface illusion
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [GoXeyColors.gxCyan, GoXeyColors.radicalRed],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: GoXeyColors.gxCyan.withOpacity(0.5),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Avatar
                    Positioned(
                      bottom: 12,
                      child: _squadMembers[_currentCollectionIndex]['status'] == "GHOST"
                        ? ColorFiltered(
                            colorFilter: const ColorFilter.matrix([
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0,      0,      0,      1, 0,
                            ]),
                            child: AvatarViewer(
                              modelUrl: _squadMembers[_currentCollectionIndex]['avatar'],
                              height: 230,
                              width: 140,
                              showBackground: false,
                            ),
                          )
                        : AvatarViewer(
                            modelUrl: _squadMembers[_currentCollectionIndex]['avatar'],
                            height: 230,
                            width: 140,
                            showBackground: false,
                          ),
                    ),
                    // Left arrow
                    Positioned(
                      left: 0,
                      top: 100,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentCollectionIndex = (_currentCollectionIndex - 1) % _squadMembers.length;
                            if (_currentCollectionIndex < 0) _currentCollectionIndex += _squadMembers.length;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                    // Right arrow
                    Positioned(
                      right: 0,
                      top: 100,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentCollectionIndex = (_currentCollectionIndex + 1) % _squadMembers.length;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Shelves (Right Section)
              Positioned(
                right: 0,
                top: 15,
                width: MediaQuery.of(context).size.width * 0.52,
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
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(child: _buildMainButton("Showcase to Squad", isPrimary: false, onTap: () => _showShowcaseDialog(context))),
            const SizedBox(width: 12),
            Expanded(child: _buildMainButton("Redeem New Box", isPrimary: true, onTap: () => _redeemNewBox(context))),
          ],
        ),
      ],
    );
  }

  Widget _buildShelf(int number, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20), // Exact margin for calculation
      height: 55, // Exact height for calculation
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          top: BorderSide(color: GoXeyColors.neonLime.withOpacity(0.4), width: 1.5),
          bottom: BorderSide(color: Colors.black.withOpacity(0.8), width: 2),
          left: BorderSide(color: Colors.white.withOpacity(0.05)),
          right: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        boxShadow: [
          BoxShadow(
            color: GoXeyColors.gxCyan.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 3D Glass Surface Reflection
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.05),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "SHELF $number: $title",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(1, 1)),
                      ],
                    ),
                  ),
                ),
                if (title.contains("DIMOO")) ...[
                  Image.asset("assets/avatars/avatar_3.jpg", height: 35, width: 35, fit: BoxFit.contain),
                  const SizedBox(width: 4),
                  Image.asset("assets/avatars/avatar_5.jpg", height: 35, width: 35, fit: BoxFit.contain),
                ],
              ],
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

  Widget _buildMainButton(String text, {required bool isPrimary, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary ? GoXeyColors.radicalRed : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isPrimary ? Colors.transparent : Colors.white10),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: GoXeyColors.radicalRed.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Create Shared Pocket", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Pocket Name (e.g. Bali Trip)",
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: "Target Amount (RM)",
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _showFriendSelectionDialog(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.person_add, color: GoXeyColors.neonLime, size: 20),
                    const SizedBox(width: 8),
                    const Text("Select Friends/Family to Add", style: TextStyle(color: GoXeyColors.neonLime)),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Shared pocket created successfully! 🚀"), backgroundColor: GoXeyColors.neonLime),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: GoXeyColors.radicalRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  void _showFriendSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Select Friends", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Search bank account number of friend/family member",
                  hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
                    _buildFriendItem(context, "Ethan", "9988776655 (Public Bank)"),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Link copied to clipboard!"), backgroundColor: GoXeyColors.neonLime),
                  );
                },
                icon: const Icon(Icons.share, size: 18, color: Colors.white),
                label: const Text("Share Invite Link", style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Done", style: TextStyle(color: GoXeyColors.neonLime))),
        ],
      ),
    );
  }

  Widget _buildFriendItem(BuildContext context, String name, String details) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: Colors.white10, child: const Icon(Icons.person, color: Colors.white54)),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(details, style: const TextStyle(color: Colors.white38, fontSize: 11)),
      trailing: const Icon(Icons.add_circle_outline, color: GoXeyColors.neonLime),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$name added!"), backgroundColor: GoXeyColors.gxPurple, duration: const Duration(seconds: 1)),
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
        title: const Text("Add to Squad", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search bank account number of friend/family member",
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.search, color: Colors.white24),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Link copied to clipboard!"), backgroundColor: GoXeyColors.neonLime),
                );
              },
              icon: const Icon(Icons.share, size: 18, color: Colors.white),
              label: const Text("Share Invite Link", style: TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 44),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invite sent!"), backgroundColor: GoXeyColors.neonLime),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: GoXeyColors.radicalRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          GoXeyColors.gxCyan.withOpacity(0.4),
          GoXeyColors.radicalRed.withOpacity(0.4)
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final path = Path();
    
    // Constants for positions based on layout
    // Top padding of shelves column = 15
    // Shelf height = 55, Margin bottom = 20
    double shelfXStart = size.width * 0.48; // Left edge of shelves
    double shelfXEnd = size.width; // Right edge of shelves
    
    List<double> shelfYLines = [
      15 + 55.0,           // Shelf 1 bottom
      15 + 55.0 + 20 + 55, // Shelf 2 bottom
      15 + (55.0 + 20) * 2 + 55, // Shelf 3 bottom
      15 + (55.0 + 20) * 3 + 55, // Shelf 4 bottom
    ];

    // Draw horizontal lines for all shelves
    for (int i = 0; i < 4; i++) {
      path.moveTo(shelfXStart, shelfYLines[i]);
      path.lineTo(shelfXEnd, shelfYLines[i]);
      
      // For top 3 shelves, draw the curved left end
      if (i < 3) {
        path.moveTo(shelfXStart, shelfYLines[i]);
        path.quadraticBezierTo(
          shelfXStart - 10, shelfYLines[i], 
          shelfXStart - 10, shelfYLines[i] + 10
        );
      }
    }

    // Draw S-curve for the bottom shelf (Shelf 4)
    double stageBottomY = 25 + 190 + 15 + 35; // Top + Avatar + spacing + Stage
    double stageRightX = size.width * 0.35; // Roughly right edge of stage
    
    path.moveTo(stageRightX, stageBottomY - 10);
    path.cubicTo(
      stageRightX + 20, stageBottomY - 10,
      shelfXStart - 20, shelfYLines[3],
      shelfXStart, shelfYLines[3],
    );

    // Vertical rack line on the right connecting all shelves
    path.moveTo(shelfXEnd, shelfYLines[0] - 20); // slightly above top shelf
    path.lineTo(shelfXEnd, shelfYLines[3] + 20); // slightly below bottom shelf

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
