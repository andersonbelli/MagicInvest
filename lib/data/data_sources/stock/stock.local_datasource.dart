import 'package:result_dart/result_dart.dart';

import '../../../shared/exceptions/exceptions.dart';
import '../../entity/stock.entity.dart';

class StockLocalDatasource {
  AsyncResult<List<Stock>> loadStocks() async {
    try {
      final box = await Stock.openStockHiveBox();
      final List<Stock> stocks = box.values.toList();

      return Success(stocks.toList());
    } catch (e, s) {
      return Failure(
        AppException(e.toString(), s),
      );
    }
  }

  AsyncResult<Unit> addStock(Stock stock) async {
    try {
      final box = await Stock.openStockHiveBox();

      return Success(await box.add(stock));
    } catch (e, s) {
      return Failure(
        AppException(e.toString(), s),
      );
    }
  }

  AsyncResult<Unit> updateStock(int stockKey, Stock stock) async {
    try {
      final box = await Stock.openStockHiveBox();

      return box.containsKey(stockKey)
          ? Success(
              await box.put(stockKey, stock),
            )
          : Failure(
              AppException('Error: Stock with key $stockKey does not exist.'),
            );
    } catch (e, s) {
      return Failure(
        AppException(e.toString(), s),
      );
    }
  }

  AsyncResult<Unit> deleteStock(int stockKey) async {
    try {
      final box = await Stock.openStockHiveBox();

      await box.delete(stockKey);

      return const Success(unit);
    } catch (e, s) {
      return Failure(
        AppException(e.toString(), s),
      );
    }
  }
}
