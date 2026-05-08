import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../core/theme.dart';
import 'squad_detail_page.dart';

class SquadPocketsPage extends StatelessWidget {
  const SquadPocketsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 30),
          FadeInLeft(
            child: _buildPocketCard(
              context,
              title: "Langkawi Trip Fund",
              saved: "RM2150",
              target: "RM5000",
              members: 4,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SquadDetailPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: _buildAddPocketCard(context),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPocketCard(
    BuildContext context, {
    required String title,
    required String saved,
    required String target,
    required int members,
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: GoXeyColors.neonLime.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "$members Members",
                    style: const TextStyle(
                      color: GoXeyColors.neonLime,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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
                    const Text(
                      "Saved",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
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
                    const Text(
                      "Target",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
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
                value: 2150 / 5000,
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
        border: Border.all(color: Colors.white10, style: BorderStyle.solid),
      ),
      child: InkWell(
        onTap: () {
          _showCreatePocketDialog(context);
        },
        borderRadius: BorderRadius.circular(24),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: GoXeyColors.radicalRed, size: 32),
            SizedBox(height: 8),
            Text(
              "Add Another Shared Saving",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
}
