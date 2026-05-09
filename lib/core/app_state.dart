import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _isGoxeyMode = false;
  double _totalBalance = 5000.00;
  double _pocketsBalance = 2150.00;
  int _usedBoxesCount = 10;
  String _avatarUrl = "https://modelviewer.dev/shared-assets/models/Astronaut.glb";

  bool get isGoxeyMode => _isGoxeyMode;
  double get totalBalance => _totalBalance;
  double get pocketsBalance => _pocketsBalance;
  String get avatarUrl => _avatarUrl;
  bool get hasCreatedAvatar => _avatarUrl != "https://modelviewer.dev/shared-assets/models/Astronaut.glb";
  int get usedBoxesCount => _usedBoxesCount;
  
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
    
    _pocketsBalance = prefs.getDouble('pocketsBalance') ?? 2150.00;
    if (_pocketsBalance == 0.00) {
      _pocketsBalance = 2150.00; // Force to 2150 if it was saved as 0 from previous runs
    }
    
    _usedBoxesCount = prefs.getInt('usedBoxesCount') ?? 10;
    if (_usedBoxesCount < 10) _usedBoxesCount = 10;
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
}
