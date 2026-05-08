import 'package:flutter/material.dart';

/// A Provider that manages the user's monthly budget, guilt debt, 
/// and automatic transfers to savings pockets.
class BudgetProvider with ChangeNotifier {
  // --- Variables ---
  double _monthlySpendingLimit = 2000.0;
  double _currentMonthSpending = 0.0;
  double _pendingGuiltDebt = 0.0;
  
  // Account balances for the logic
  double _mainAccountBalance = 1500.0;
  double _pocketBalance = 500.0;
  
  // Constants / Limits
  double _minimumMainBalance = 100.0;

  // --- Getters ---
  double get monthlySpendingLimit => _monthlySpendingLimit;
  double get currentMonthSpending => _currentMonthSpending;
  double get pendingGuiltDebt => _pendingGuiltDebt;
  double get mainAccountBalance => _mainAccountBalance;
  double get pocketBalance => _pocketBalance;
  double get minimumMainBalance => _minimumMainBalance;

  // --- Logic ---

  /// The Calculation: Runs at the start of a new month (or when triggered).
  /// Evaluates overspending and attempts to transfer funds to the pocket.
  void evaluateMonthlyBudget() {
    double overspentAmount = _currentMonthSpending - _monthlySpendingLimit;
    
    if (overspentAmount > 0) {
      _processAutoTransfer(overspentAmount);
    }
    
    // Reset spending for the new month
    _currentMonthSpending = 0.0;
    notifyListeners();
  }

  /// The Auto-Transfer Logic & Safety Limit
  void _processAutoTransfer(double amount) {
    // Check how much we can actually transfer while maintaining the Safety Limit
    double availableToTransfer = _mainAccountBalance - _minimumMainBalance;
    
    if (availableToTransfer <= 0) {
      // Cannot transfer anything, full amount becomes debt
      _pendingGuiltDebt += amount;
    } else if (availableToTransfer >= amount) {
      // We can cover the full amount
      _mainAccountBalance -= amount;
      _pocketBalance += amount;
    } else {
      // Partial transfer: take what we can, rest becomes debt
      _mainAccountBalance -= availableToTransfer;
      _pocketBalance += availableToTransfer;
      
      // The Debt System: store remaining in pendingGuiltDebt
      double remainingDebt = amount - availableToTransfer;
      _pendingGuiltDebt += remainingDebt;
    }
  }

  /// The Recovery Trigger: Checks for debt when funds are deposited.
  void onDeposit(double amount) {
    _mainAccountBalance += amount;
    
    // If there is debt, redirect funds from main account to pocket immediately
    if (_pendingGuiltDebt > 0) {
      double recoveryAmount = amount;
      
      if (recoveryAmount > _pendingGuiltDebt) {
        recoveryAmount = _pendingGuiltDebt;
      }
      
      // Transfer the recovery amount
      _mainAccountBalance -= recoveryAmount;
      _pocketBalance += recoveryAmount;
      _pendingGuiltDebt -= recoveryAmount;
    }
    
    notifyListeners();
  }

  // --- Helper methods for demo ---
  void addSpending(double amount) {
    _currentMonthSpending += amount;
    notifyListeners();
  }
  
  void setSpendingLimit(double limit) {
    _monthlySpendingLimit = limit;
    notifyListeners();
  }

  void setMinimumMainBalance(double limit) {
    _minimumMainBalance = limit;
    notifyListeners();
  }
}
