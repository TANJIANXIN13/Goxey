import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _isGoxeyMode = false;
  late double _totalBalance;
  late double _pocketsBalance;

  bool get isGoxeyMode => _isGoxeyMode;
  double get totalBalance => _totalBalance;
  double get pocketsBalance => _pocketsBalance;

  AppState() {
    _randomizeBalances();
    _loadMode();
  }

  void _randomizeBalances() {
    final random = Random();
    _totalBalance = 1000 + random.nextDouble() * 9000; // RM 1000 - 10000
    _pocketsBalance = 50 + random.nextDouble() * 500; // RM 50 - 550
  }

  Future<void> _loadMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isGoxeyMode = prefs.getBool('isGoxeyMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleMode() async {
    _isGoxeyMode = !_isGoxeyMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGoxeyMode', _isGoxeyMode);
    notifyListeners();
  }
}
