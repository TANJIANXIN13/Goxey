import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/pocket_provider.dart';
import 'squad_detail_page.dart';

class SquadPocketsPage extends StatelessWidget {
  const SquadPocketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PocketProvider>(
      builder: (context, pocketProvider, child) {
        final pockets = pocketProvider.pockets;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "YOUR SQUAD POCKETS",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Shared savings with your squad",
                style: TextStyle(fontSize: 14, color: Colors.white54),
              ),
              const SizedBox(height: 30),
              ...List.generate(pockets.length, (i) {
                final pocket = pockets[i];
                final progress = pocket.target > 0 ? (pocket.saved / pocket.target).clamp(0.0, 1.0) : 0.0;
                return FadeInLeft(
                  delay: Duration(milliseconds: i * 100),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildPocketCard(
                      context,
                      title: pocket.name,
                      saved: "RM${pocket.saved.toStringAsFixed(0)}",
                      target: "RM${pocket.target.toStringAsFixed(0)}",
                      members: pocket.members,
                      progress: progress,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SquadDetailPage(pocket: pocket)),
                        );
                      },
                    ),
                  ),
                );
              }),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: _buildAddPocketCard(context),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPocketCard(
    BuildContext context, {
    required String title,
    required String saved,
    required String target,
    required List<String> members,
    required double progress,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              GoXeyColors.accentPurple.withOpacity(0.8),
              GoXeyColors.radicalRed.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: GoXeyColors.gxPurple.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: GoXeyColors.neonLime.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${members.length + 1} Members",
                    style: const TextStyle(
                      color: GoXeyColors.neonLime,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people_outline, color: Colors.white54, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    members.isEmpty ? "Me" : "Me, ${members.join(', ')}",
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Saved", style: TextStyle(color: Colors.white54, fontSize: 12)),
                    Text(
                      saved,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: GoXeyColors.neonLime,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Target", style: TextStyle(color: Colors.white54, fontSize: 12)),
                    Text(
                      target,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation<Color>(GoXeyColors.neonLime),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPocketCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: InkWell(
        onTap: () => _showCreatePocketDialog(context),
        borderRadius: BorderRadius.circular(24),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: GoXeyColors.radicalRed, size: 32),
            SizedBox(height: 8),
            Text(
              "Add Another Shared Saving",
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePocketDialog(BuildContext context) {
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    final List<String> selectedMembers = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
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
                    hintText: "Pocket name (e.g. Bali Trip)",
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Target amount (e.g. 3000)",
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
                // Pre-existing friends list
                ...["Liam – 1029384756 (Maybank)", "Tom – 5647382910 (CIMB)", "Ethan – 9988776655 (Public Bank)"].map(
                  (friend) {
                    final name = friend.split(' ')[0];
                    final isSelected = selectedMembers.contains(name);
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(backgroundColor: Colors.white10, radius: 16, child: const Icon(Icons.person, color: Colors.white54, size: 16)),
                      title: Text(friend, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      trailing: GestureDetector(
                        onTap: () => setState(() {
                          if (isSelected) selectedMembers.remove(name);
                          else selectedMembers.add(name);
                        }),
                        child: Icon(
                          isSelected ? Icons.check_circle : Icons.add_circle_outline,
                          color: isSelected ? GoXeyColors.neonLime : Colors.white38,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invite link copied!"), backgroundColor: GoXeyColors.neonLime),
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
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.white38))),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final target = double.tryParse(targetController.text) ?? 0;
                if (name.isNotEmpty && target > 0) {
                  Provider.of<PocketProvider>(context, listen: false).addPocket(name, target, selectedMembers);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("\"$name\" pocket created! 🚀"), backgroundColor: GoXeyColors.neonLime),
                  );
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
                    _buildFriendItem(context, "Tom", "5647382910 (CIMB)"),
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
}
