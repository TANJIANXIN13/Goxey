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
  final Map<String, int> _pullCounts = {};
  
  final List<Pocket> _pockets = [
    Pocket(
      name: "Langkawi Trip Fund",
      target: 5000,
      saved: 2150,
      members: ["Liam", "Tom", "Ethan"],
      activities: [
        PocketActivity(
          name: "Liam",
          content:
              "Deposited RM150 into the Langkawi Trip Fund pocket! 🏖️ We are getting closer!",
          time: "2 hours ago",
        ),
        PocketActivity(
          name: "Tom",
          content: "Just opened a DIMOO box and got the DIMOO series! 🌟",
          time: "5 hours ago",
          isBoxUpdate: true,
          boxImage: "assets/avatars/dimoo/dimoo_new_1.png",
        ),
      ],
    ),
  ];

  final Map<String, List<String>> _userOwnedCollections = {
    "DIMOO": ["dimoo_new_1.png", "dimoo_new_3.png"],
    "CRYBABY SERIES": ["crybaby1.webp", "crybaby2.webp", "crybaby5.webp"],
    "SKULLPANDA": ["skullpanda2.webp", "skullpanda5.webp"],
    "TWINKLE TWINKLE": ["twinkle twinkle 1.webp", "twinkle twinkle 4.webp"],
    "MOLLY": ["molly1.webp", "molly5.webp"],
    "GX SERIES": ["gx1.png", "gx2.png"],
  };

  List<Pocket> get pockets => List.unmodifiable(_pockets);
  double get totalSaved => _pockets.fold(0, (sum, p) => sum + p.saved);
  Map<String, List<String>> get userOwnedCollections => _userOwnedCollections;

  void addPocket(String name, double target, List<String> members) {
    _pockets.add(Pocket(name: name, target: target, members: members));
    notifyListeners();
  }

  void addMoneyToPocket(Pocket pocket, double amount) {
    final index = _pockets.indexWhere((p) => p.name == pocket.name);
    if (index != -1) {
      _pockets[index].saved += amount;


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

  void recordBlindBoxOpen(String seriesName, String imagePath, {bool isUpdate = false}) {
    if (!isUpdate) {
      _pullCounts[seriesName] = (_pullCounts[seriesName] ?? 0) + 1;
    }
    

    final normalizedSeriesName = seriesName.toUpperCase();
    final parts = imagePath.split('/');
    String fileName = parts.last;
    if (parts.length >= 2 && parts[parts.length - 2] == 'custom') {
      fileName = 'custom/$fileName';
    }
    

    String key = normalizedSeriesName;
    if (key == "DIMOO") key = "DIMOO";
    else if (key == "GX SERIES") key = "GX SERIES";
    else if (key.contains("MOLLY")) key = "MOLLY";
    else if (key.contains("CRYBABY")) key = "CRYBABY SERIES";
    else if (key.contains("SKULLPANDA")) key = "SKULLPANDA";
    
    if (!_userOwnedCollections.containsKey(key)) {
      _userOwnedCollections[key] = [];
    }
    
    if (isUpdate && _userOwnedCollections[key]!.isNotEmpty) {

      _userOwnedCollections[key]!.removeLast();
    }

    if (!_userOwnedCollections[key]!.contains(fileName)) {
      _userOwnedCollections[key]!.add(fileName);
    }

    for (var i = 0; i < _pockets.length; i++) {
      if (isUpdate && _pockets[i].activities.isNotEmpty && _pockets[i].activities.first.isBoxUpdate) {
        _pockets[i].activities.removeAt(0);
      }
      
      _pockets[i].activities.insert(
        0,
        PocketActivity(
          name: "Me",
          content: isUpdate 
            ? "Just customized my $seriesName figure! ✨" 
            : "Just opened a $seriesName box and got a new figure! 🌟",
          time: "Just Now",
          isBoxUpdate: true,
          boxImage: imagePath,
        ),
      );
    }
    notifyListeners();
  }

  int getPullCount(String seriesName) => _pullCounts[seriesName] ?? 0;
}
