import 'package:hive_flutter/hive_flutter.dart';

import '../../models/stock.model.dart';

class StockPersistence {
  static const _stockBoxName = 'stocks';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(StockAdapter());
  }

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
