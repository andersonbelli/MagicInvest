import 'package:flutter/foundation.dart';

import '../../data/repositories/stock.repository.dart';
import '../../domain/model/stock.model.dart';

class StockViewModel extends ChangeNotifier {
  List<StockModel> _stocks = [];

  List<StockModel> get stocks => _stocks;

  final StockRepository stockRepository;

  StockViewModel({required this.stockRepository});

  Future<void> loadStocks() async {
    _stocks = await stockRepository.loadStocks();
    notifyListeners();
  }

  Future<void> addStock(StockModel stock) async {
    await stockRepository.addStock(stock);
  }

  Future<void> updateStock(int stockKey, StockModel stock) async {
    await stockRepository.updateStock(stockKey, stock);
  }

  Future<void> deleteStock(StockModel stock) async {
    await stockRepository.deleteStock(stock);
  }

  double calculateMonthlyDividend(StockModel stock) {
    return (stock.dividendYield / 100) * stock.investedAmount / 12;
  }

  double calculatePortfolioPercentage(StockModel stock) {
    final double totalInvested =
        _stocks.fold(0, (sum, s) => sum + s.investedAmount);
    return (totalInvested > 0)
        ? (stock.investedAmount / totalInvested) * 100
        : 0;
  }

  double calculateMagicNumber(StockModel stock) {
    return stock.currentPrice /
        ((stock.currentPrice * stock.dividendYield) / 12 / 100);
  }

  int calculateStocksNeededForMagicNumber(StockModel stock) {
    final double magicNumber = calculateMagicNumber(stock);
    final int currentStocksQuantity =
        (stock.investedAmount / stock.currentPrice).round();
    return (magicNumber - currentStocksQuantity).round();
  }

  double calculateAdditionalInvestmentNeeded(StockModel stock) {
    final int stocksNeeded = calculateStocksNeededForMagicNumber(stock);
    return stocksNeeded * stock.currentPrice;
  }

  int calculateCurrentStocksQuantity(StockModel stock) {
    return (stock.investedAmount / stock.currentPrice).floor();
  }
}
