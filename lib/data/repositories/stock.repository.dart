import 'package:result_dart/result_dart.dart';

import '../../domain/model/stock.model.dart';
import '../data_sources/stock/stock.local_datasource.dart';
import '../entity/stock.entity.dart';

abstract interface class StockRepository {
  AsyncResult<List<StockModel>> loadStocks();

  AsyncResult<Unit> addStock(StockModel stock);

  AsyncResult<Unit> updateStock(int stockKey, StockModel stock);

  AsyncResult<Unit> deleteStock(StockModel stock);
}

class StockRepositoryImpl implements StockRepository {
  final StockLocalDatasource localDataSource;

  StockRepositoryImpl({
    required this.localDataSource,
  });

  @override
  AsyncResult<List<StockModel>> loadStocks() async =>
      localDataSource.loadStocks().fold(
            (stocks) => Success(
              stocks.map((stock) => StockModel.fromEntity(stock)).toList(),
            ),
            (error) => Failure(error),
          );

  @override
  AsyncResult<Unit> addStock(StockModel stock) async =>
      localDataSource.addStock(
        Stock.fromModel(stock),
      );

  @override
  AsyncResult<Unit> deleteStock(StockModel stock) async =>
      localDataSource.deleteStock(stock.key!);

  @override
  AsyncResult<Unit> updateStock(int stockKey, StockModel stock) async =>
      localDataSource.updateStock(
        stockKey,
        Stock.fromModel(stock),
      );
}
