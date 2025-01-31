import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/stock.model.dart';

class StockViewModel extends ChangeNotifier {
  List<Stock> _stocks = [];

  List<Stock> get stocks => _stocks;

  Future<void> loadStocks() async {
    try {
      final box = await Hive.openBox<Stock>('stocks');
      _stocks = box.values.toList();

      notifyListeners();
    } catch (e) {
      // Handle the error (e.g., log it or show a message)
      print('Error loading stocks: $e');
    }
  }

  Future<void> addStock(Stock stock) async {
    try {
      final box = await Hive.openBox<Stock>('stocks');

      await box.add(stock);
      _stocks.add(stock);
      notifyListeners();
    } catch (e) {
      // Handle the error
      print('Error adding stock: $e');
    }
  }

  Future<void> updateStock(int stockKey, Stock stock) async {
    try {
      final box = await Hive.openBox<Stock>('stocks');

      // Check if the stock exists in the box
      if (box.containsKey(stockKey)) {
        // Update directly in the box
        await box.put(stockKey, stock);
        notifyListeners(); // Notify listeners about changes
      } else {
        print('Error: Stock with key ${stockKey} does not exist.');
      }
    } catch (e) {
      print('Error updating stock: $e');
    }
  }

  Future<void> deleteStock(Stock stock) async {
    try {
      final box = await Hive.openBox<Stock>('stocks');
      await box.delete(stock.key);
      _stocks.remove(stock);
      notifyListeners();
    } catch (e) {
      print('Error deleting stock: $e');
    }
  }

  double calculateMonthlyDividend(Stock stock) {
    return (stock.dividendYield / 100) * stock.investedAmount / 12;
  }

  double calculatePortfolioPercentage(Stock stock) {
    final double totalInvested =
        _stocks.fold(0, (sum, s) => sum + s.investedAmount);
    return (totalInvested > 0)
        ? (stock.investedAmount / totalInvested) * 100
        : 0;
  }

  double calculateMagicNumber(Stock stock) {
    return stock.currentPrice /
        ((stock.currentPrice * stock.dividendYield) / 12 / 100);
  }

  int calculateStocksNeededForMagicNumber(Stock stock) {
    final double magicNumber = calculateMagicNumber(stock);
    final int currentStocksQuantity =
        (stock.investedAmount / stock.currentPrice).round();
    return (magicNumber - currentStocksQuantity).round();
  }

  double calculateAdditionalInvestmentNeeded(Stock stock) {
    final int stocksNeeded = calculateStocksNeededForMagicNumber(stock);
    return stocksNeeded * stock.currentPrice;
  }

  int calculateCurrentStocksQuantity(Stock stock) {
    return (stock.investedAmount / stock.currentPrice).floor();
  }
}
