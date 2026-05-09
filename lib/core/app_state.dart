import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _isGoxeyMode = false;
  double _totalBalance = 5000.00;
  double _pocketsBalance = 2150.00;
  int _usedBoxesCount = 10;
  String _avatarUrl =
      "https://modelviewer.dev/shared-assets/models/Astronaut.glb";
  final List<Map<String, dynamic>> _transactions = [
    {"name": "Starbucks Coffee", "category": "Food & Drink", "amount": -18.50, "icon": Icons.local_cafe, "color": Colors.greenAccent, "date": "Today"},
    {"name": "Steam Purchase", "category": "Gaming", "amount": -120.00, "icon": Icons.games, "color": Colors.cyanAccent, "date": "Today"},
    {"name": "Grab Ride", "category": "Transport", "amount": -15.00, "icon": Icons.directions_car, "color": Colors.yellowAccent, "date": "Yesterday"},
    {"name": "Monthly Salary", "category": "Income", "amount": 5500.00, "icon": Icons.account_balance_wallet, "color": Colors.pinkAccent, "date": "Yesterday"},
    {"name": "Uniqlo", "category": "Shopping", "amount": -89.00, "icon": Icons.shopping_bag, "color": Colors.orangeAccent, "date": "2 days ago"},
  ];

  int _lastRedeemedMilestone = 0;

  bool get isGoxeyMode => _isGoxeyMode;
  double get totalBalance => _totalBalance;
  double get pocketsBalance => _pocketsBalance;
  String get avatarUrl => _avatarUrl;
  List<Map<String, dynamic>> get transactions => _transactions;
  bool get hasCreatedAvatar =>
      _avatarUrl !=
      "https://modelviewer.dev/shared-assets/models/Astronaut.glb";
  int get usedBoxesCount => _usedBoxesCount;
  int get lastRedeemedMilestone => _lastRedeemedMilestone;

  // Every RM 200 gives 1 box
  int get availableBoxes => (_pocketsBalance ~/ 200) - _usedBoxesCount;
  double get progressToNextBox => (_pocketsBalance % 200) / 200;

  void markRedemptionTriggered(int milestone) {
    _lastRedeemedMilestone = milestone;
    notifyListeners();
  }

  AppState() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _isGoxeyMode = prefs.getBool('isGoxeyMode') ?? false;
    _totalBalance = 5000.00; // Always start with 5k as requested

    _pocketsBalance = 2150.00; // Force to initial state
    _usedBoxesCount = 10;     // Force to initial state
    await prefs.setDouble('pocketsBalance', _pocketsBalance);
    await prefs.setInt('usedBoxesCount', _usedBoxesCount);
    _avatarUrl =
        prefs.getString('avatarUrl') ??
        "https://modelviewer.dev/shared-assets/models/Astronaut.glb";
    notifyListeners();
  }

  Future<void> toggleMode() async {
    _isGoxeyMode = !_isGoxeyMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGoxeyMode', _isGoxeyMode);
    notifyListeners();
  }

  Future<void> updateAvatarUrl(String url) async {
    _avatarUrl = url;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatarUrl', url);
    notifyListeners();
  }

  Future<void> addMoneyToMainAccount(double amount) async {
    if (amount > 0) {
      _totalBalance += amount;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('totalBalance', _totalBalance);
      notifyListeners();
    }
  }

  Future<void> transferToPockets(double amount) async {
    if (amount <= _totalBalance) {
      _totalBalance -= amount;
      _pocketsBalance += amount;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('totalBalance', _totalBalance);
      await prefs.setDouble('pocketsBalance', _pocketsBalance);

      notifyListeners();
    }
  }

  Future<void> openBlindBox() async {
    if (availableBoxes > 0) {
      _usedBoxesCount++;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('usedBoxesCount', _usedBoxesCount);

      notifyListeners();
    }
  }

  void addTransaction({
    required String name,
    required String category,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    _transactions.insert(0, {
      "name": name,
      "category": category,
      "amount": amount,
      "icon": icon,
      "color": color,
      "date": "Just now",
    });
    notifyListeners();
  }
}
