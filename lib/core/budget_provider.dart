import 'package:flutter/material.dart';



class BudgetProvider with ChangeNotifier {

  double _monthlySpendingLimit = 2000.0;
  double _currentMonthSpending = 0.0;
  double _pendingGuiltDebt = 0.0;
  

  double _mainAccountBalance = 1500.0;
  double _pocketBalance = 500.0;
  

  double _minimumMainBalance = 100.0;


  double get monthlySpendingLimit => _monthlySpendingLimit;
  double get currentMonthSpending => _currentMonthSpending;
  double get pendingGuiltDebt => _pendingGuiltDebt;
  double get mainAccountBalance => _mainAccountBalance;
  double get pocketBalance => _pocketBalance;
  double get minimumMainBalance => _minimumMainBalance;





  void evaluateMonthlyBudget() {
    double overspentAmount = _currentMonthSpending - _monthlySpendingLimit;
    
    if (overspentAmount > 0) {
      _processAutoTransfer(overspentAmount);
    }
    

    _currentMonthSpending = 0.0;
    notifyListeners();
  }


  void _processAutoTransfer(double amount) {

    double availableToTransfer = _mainAccountBalance - _minimumMainBalance;
    
    if (availableToTransfer <= 0) {

      _pendingGuiltDebt += amount;
    } else if (availableToTransfer >= amount) {

      _mainAccountBalance -= amount;
      _pocketBalance += amount;
    } else {

      _mainAccountBalance -= availableToTransfer;
      _pocketBalance += availableToTransfer;
      

      double remainingDebt = amount - availableToTransfer;
      _pendingGuiltDebt += remainingDebt;
    }
  }


  void onDeposit(double amount) {
    _mainAccountBalance += amount;
    

    if (_pendingGuiltDebt > 0) {
      double recoveryAmount = amount;
      
      if (recoveryAmount > _pendingGuiltDebt) {
        recoveryAmount = _pendingGuiltDebt;
      }
      

      _mainAccountBalance -= recoveryAmount;
      _pocketBalance += recoveryAmount;
      _pendingGuiltDebt -= recoveryAmount;
    }
    
    notifyListeners();
  }


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
