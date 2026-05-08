import 'package:flutter/material.dart';

class Pocket {
  final String name;
  final double target;
  double saved;
  final List<String> members; // member names/bank accounts

  Pocket({
    required this.name,
    required this.target,
    this.saved = 0,
    List<String>? members,
  }) : members = members ?? [];
}

class PocketProvider extends ChangeNotifier {
  final List<Pocket> _pockets = [
    Pocket(
      name: "Langkawi Trip Fund",
      target: 5000,
      saved: 2150,
      members: ["Liam", "Chloe", "Ethan"],
    ),
  ];

  List<Pocket> get pockets => List.unmodifiable(_pockets);

  void addPocket(String name, double target, List<String> members) {
    _pockets.add(Pocket(name: name, target: target, members: members));
    notifyListeners();
  }
}
