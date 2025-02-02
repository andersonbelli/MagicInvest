import 'package:hive_flutter/hive_flutter.dart';

import '../../entity/stock.entity.dart';

class StockLocalDatasource {
  static const _stockBoxName = 'stocks';

  static Future<void> saveStocks(List<Stock> stocks) async {
    final box = await Hive.openBox<Stock>(_stockBoxName);
    await box.clear();
    await box.addAll(stocks);
  }

  static Future<List<Stock>> loadStocks() async {
    final box = await Hive.openBox<Stock>(_stockBoxName);
    return box.values.toList();
  }
}
