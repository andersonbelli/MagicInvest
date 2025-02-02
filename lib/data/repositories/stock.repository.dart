import 'package:hive/hive.dart';

import '../../domain/model/stock.model.dart';
import '../data_sources/stock/stock.local_datasource.dart';
import '../entity/stock.entity.dart';

abstract interface class StockRepository {
  Future<List<StockModel>> loadStocks();

  Future<void> addStock(StockModel stock);

  Future<void> updateStock(int stockKey, StockModel stock);

  Future<void> deleteStock(StockModel stock);
}

class StockRepositoryImpl implements StockRepository {
  final StockLocalDatasource localDataSource;

  StockRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<StockModel>> loadStocks() async {
    try {
      final box = await Hive.openBox<Stock>('stocks');
      final List<Stock> stocks = box.values.toList();

      return stocks.map((stock) => StockModel.fromEntity(stock)).toList();
    } catch (e) {
      // Handle the error (e.g., log it or show a message)
      print('Error loading stocks: $e');
      rethrow;
    }
  }

  @override
  Future<void> addStock(StockModel stock) async {
    try {
      final box = await Hive.openBox<Stock>('stocks');

      await box.add(
        Stock.fromModel(stock),
      );
    } catch (e) {
      // Handle the error
      print('Error adding stock: $e');
    }
  }

  @override
  Future<void> deleteStock(StockModel stock) async {
    try {
      final box = await Hive.openBox<Stock>('stocks');
      await box.delete(stock.key);
    } catch (e) {
      print('Error deleting stock: $e');
    }
  }

  @override
  Future<void> updateStock(int stockKey, StockModel stock) async {
    try {
      final box = await Hive.openBox<Stock>('stocks');

      if (box.containsKey(stockKey)) {
        await box.put(stockKey, Stock.fromModel(stock));
      } else {
        print('Error: Stock with key ${stockKey} does not exist.');
      }
    } catch (e) {
      print('Error updating stock: $e');
    }
  }
}
