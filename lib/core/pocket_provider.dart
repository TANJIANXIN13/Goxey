import 'package:flutter/material.dart';

class PocketActivity {
  final String name;
  final String content;
  final String time;
  final bool isBoxUpdate;
  final String? boxImage;

  PocketActivity({
    required this.name,
    required this.content,
    required this.time,
    this.isBoxUpdate = false,
    this.boxImage,
  });
}

class Pocket {
  final String name;
  final double target;
  double saved;
  final List<String> members;
  final List<PocketActivity> activities;

  Pocket({
    required this.name,
    required this.target,
    this.saved = 0,
    List<String>? members,
    List<PocketActivity>? activities,
  }) : members = members ?? [],
       activities = activities ?? [];
}

class PocketProvider extends ChangeNotifier {
  final List<Pocket> _pockets = [
    Pocket(
      name: "Langkawi Trip Fund",
      target: 5000,
      saved: 2150,
      members: ["Liam", "Chloe", "Ethan"],
      activities: [
        PocketActivity(
          name: "Liam",
          content:
              "Deposited RM150 into the Langkawi Trip Fund pocket! 🏖️ We are getting closer!",
          time: "2 hours ago",
        ),
        PocketActivity(
          name: "Chloe",
          content: "Just opened a DIMOO box and got the DIMOO series! 🌟",
          time: "5 hours ago",
          isBoxUpdate: true,
          boxImage: "assets/avatars/dimoo/dimoo_new_1.png",
        ),
      ],
    ),
  ];

  List<Pocket> get pockets => List.unmodifiable(_pockets);

  double get totalSaved => _pockets.fold(0, (sum, p) => sum + p.saved);

  void addPocket(String name, double target, List<String> members) {
    _pockets.add(Pocket(name: name, target: target, members: members));
    notifyListeners();
  }

  void addMoneyToPocket(Pocket pocket, double amount) {
    final index = _pockets.indexWhere((p) => p.name == pocket.name);
    if (index != -1) {
      _pockets[index].saved += amount;

      // Record milestone
      _pockets[index].activities.insert(
        0,
        PocketActivity(
          name: "You",
          content:
              "Deposited RM${amount.toStringAsFixed(0)} into the ${_pockets[index].name}! Let's go team!",
          time: "Just Now",
        ),
      );

      notifyListeners();
    }
  }

  void recordBlindBoxOpen(String seriesName, String imagePath) {
    for (var i = 0; i < _pockets.length; i++) {
      _pockets[i].activities.insert(
        0,
        PocketActivity(
          name: "Me",
          content: "Just opened a $seriesName box and got a new figure! 🌟",
          time: "Just Now",
          isBoxUpdate: true,
          boxImage: imagePath,
        ),
      );
    }
    notifyListeners();
  }
}
