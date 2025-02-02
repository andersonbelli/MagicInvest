import '../../entity/stock.entity.dart';

class StockLocalDatasource {
  static Future<void> saveStocks(List<Stock> stocks) async {
    final box = await Stock.openStockHiveBox();
    await box.clear();
    await box.addAll(stocks);
  }

  static Future<List<Stock>> loadStocks() async {
    final box = await Stock.openStockHiveBox();
    return box.values.toList();
  }
}
