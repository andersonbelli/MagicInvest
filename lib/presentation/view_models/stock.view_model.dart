import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';

import '../../data/repositories/stock.repository.dart';
import '../../domain/model/stock.model.dart';

class StockViewModel extends ChangeNotifier {
  List<StockModel> _stocks = [];

  List<StockModel> get stocks => _stocks;

  final _errorMessageController = StreamController<String?>.broadcast();

  Stream<String?> get errorMessageStream => _errorMessageController.stream;

  final StockRepository stockRepository;

  StockViewModel({required this.stockRepository});

  Future<void> loadStocks() async {
    await stockRepository
        .loadStocks()
        .onSuccess((stocks) => _stocks = stocks)
        .onFailure((e) => _errorMessageController.add(e.toString()));
    notifyListeners();
  }

  Future<void> addStock(StockModel stock) async => stockRepository
      .addStock(stock)
      .onFailure((e) => _errorMessageController.add(e.toString()));

  Future<void> updateStock(int stockKey, StockModel stock) async =>
      stockRepository
          .updateStock(stockKey, stock)
          .onFailure((e) => _errorMessageController.add(e.toString()));

  Future<void> deleteStock(StockModel stock) async => stockRepository
      .deleteStock(stock)
      .onFailure((e) => _errorMessageController.add(e.toString()));

  double calculateMonthlyDividend(StockModel stock) =>
      (stock.dividendYield / 100) * stock.investedAmount / 12;

  double calculatePortfolioPercentage(StockModel stock) {
    final double totalInvested =
        _stocks.fold(0, (sum, s) => sum + s.investedAmount);
    return (totalInvested > 0)
        ? (stock.investedAmount / totalInvested) * 100
        : 0;
  }

  double calculateMagicNumber(StockModel stock) =>
      stock.currentPrice /
      ((stock.currentPrice * stock.dividendYield) / 12 / 100);

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

  int calculateCurrentStocksQuantity(StockModel stock) =>
      (stock.investedAmount / stock.currentPrice).floor();

  @override
  void dispose() {
    _errorMessageController.close();
    super.dispose();
  }
}
