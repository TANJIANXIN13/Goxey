import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
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
    {"name": "Me", "avatar": "assets/avatars/avatar_3.jpg", "isMe": true, "status": "ACTIVE"},
    {"name": "Liam", "avatar": "assets/avatars/avatar_2.jpg", "isMe": false, "status": "ACTIVE"},
    {"name": "Chloe", "avatar": "assets/avatars/avatar_5.jpg", "isMe": false, "status": "ACTIVE"},
    {"name": "Ethan", "avatar": "assets/avatars/avatar_4.jpg", "isMe": false, "status": "GHOST"},
  ];

  final Map<String, String> _seriesStats = {
    "CRYBABY SERIES": "5/10",
    "SKULLPANDA": "3/10",
    "DIMOO": "3/10",
    "TWINKLE TWINKLE": "3/10",
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
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E24),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 12,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            // Neon glowing edge
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [GoXeyColors.gxCyan, GoXeyColors.radicalRed],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: GoXeyColors.gxCyan.withOpacity(0.8),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
      margin: const EdgeInsets.only(bottom: 25), 
      height: 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Shelf Title and figurines
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    "SHELF $number: $title",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.8),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (title.contains("DIMOO")) ...[
                  ...["assets/avatars/dimoo/dimoo_1.png", "assets/avatars/dimoo/dimoo_2.png", "assets/avatars/dimoo/dimoo_3.png"].map(
                    (path) => Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Image.asset(path, height: 45, width: 28, fit: BoxFit.contain),
                    ),
                  ),
                ] else if (title.contains("CRYBABY")) ...[
                   const Icon(Icons.star, color: Colors.amber, size: 20),
                   const Icon(Icons.star, color: Colors.amber, size: 20),
                ] else ...[
                  const Icon(Icons.lock_outline, color: Colors.white12, size: 18),
                ],
                const SizedBox(width: 10),
                // Owned Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: GoXeyColors.neonLime.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: GoXeyColors.neonLime.withOpacity(0.3)),
                  ),
                  child: Text(
                    "OWNED: ${_seriesStats[title] ?? '0/10'}",
                    style: const TextStyle(
                      color: GoXeyColors.neonLime,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    final List<String> selectedMembers = [];
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text("Create Shared Pocket", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Invite Members", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...["Liam – 1029384756 (Maybank)", "Chloe – 5647382910 (CIMB)", "Ethan – 9988776655 (Public Bank)"].map((friend) {
                  final name = friend.split(' ')[0];
                  final isSelected = selectedMembers.contains(name);
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundColor: Colors.white10, radius: 16, child: const Icon(Icons.person, color: Colors.white54, size: 16)),
                    title: Text(friend, style: const TextStyle(color: Colors.white, fontSize: 13)),
                    trailing: GestureDetector(
                      onTap: () => setDlgState(() {
                        if (isSelected) selectedMembers.remove(name); else selectedMembers.add(name);
                      }),
                      child: Icon(isSelected ? Icons.check_circle : Icons.add_circle_outline, color: isSelected ? GoXeyColors.neonLime : Colors.white38),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invite link copied!"), backgroundColor: GoXeyColors.neonLime)); },
                  icon: const Icon(Icons.share, size: 18, color: Colors.white),
                  label: const Text("Share Invite Link", style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.white38))),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final target = double.tryParse(targetController.text) ?? 0;
                if (name.isNotEmpty && target > 0) {
                  Provider.of<PocketProvider>(context, listen: false).addPocket(name, target, List.from(selectedMembers));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"$name" pocket created! 🚀'), backgroundColor: GoXeyColors.neonLime));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: GoXeyColors.radicalRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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

    double shelfXStart = size.width * 0.45; 
    double shelfXEnd = size.width; 
    
    // Y positions of the shelf lines
    List<double> shelfYLines = [
      15 + 50.0,           
      15 + 50.0 + 25 + 50, 
      15 + (50.0 + 25) * 2 + 50, 
      15 + (50.0 + 25) * 3 + 50, 
    ];

    for (int i = 0; i < 4; i++) {
      // Horizontal shelf line
      path.moveTo(shelfXStart, shelfYLines[i]);
      path.lineTo(shelfXEnd, shelfYLines[i]);
      
      // Right vertical cap for each shelf
      path.moveTo(shelfXEnd, shelfYLines[i]);
      path.lineTo(shelfXEnd, shelfYLines[i] - 15);
      
      // Upward curve at left end
      path.moveTo(shelfXStart, shelfYLines[i]);
      path.quadraticBezierTo(
        shelfXStart - 12, shelfYLines[i], 
        shelfXStart - 12, shelfYLines[i] - 12
      );
    }

    // Right vertical spine connecting the caps (aesthetic)
    path.moveTo(shelfXEnd, shelfYLines[0] - 15);
    path.lineTo(shelfXEnd, shelfYLines[3]);

    // Connecting curve from avatar stage
    double stageBottomY = 25 + 230 + 15; 
    double stageRightX = 140; 
    
    path.moveTo(stageRightX, stageBottomY);
    path.cubicTo(
      stageRightX + 30, stageBottomY,
      shelfXStart - 30, shelfYLines[3],
      shelfXStart, shelfYLines[3],
    );

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
