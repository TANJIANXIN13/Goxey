import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _isGoxeyMode = false;
  double _totalBalance = 5000.00;
  double _pocketsBalance = 0.00;
  int _usedBoxesCount = 0;
  String _avatarUrl = "https://modelviewer.dev/shared-assets/models/Astronaut.glb";

  bool get isGoxeyMode => _isGoxeyMode;
  double get totalBalance => _totalBalance;
  double get pocketsBalance => _pocketsBalance;
  String get avatarUrl => _avatarUrl;
  bool get hasCreatedAvatar => _avatarUrl != "https://modelviewer.dev/shared-assets/models/Astronaut.glb";
  
  // Every RM 200 gives 1 box
  int get availableBoxes => (_pocketsBalance ~/ 200) - _usedBoxesCount;
  double get progressToNextBox => (_pocketsBalance % 200) / 200;

  AppState() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _isGoxeyMode = prefs.getBool('isGoxeyMode') ?? false;
    _totalBalance = prefs.getDouble('totalBalance') ?? 5000.00;
    _pocketsBalance = prefs.getDouble('pocketsBalance') ?? 0.00;
    _usedBoxesCount = prefs.getInt('usedBoxesCount') ?? 0;
    _avatarUrl = prefs.getString('avatarUrl') ?? "https://modelviewer.dev/shared-assets/models/Astronaut.glb";
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
}
