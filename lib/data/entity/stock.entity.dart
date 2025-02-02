import 'package:hive/hive.dart';

import '../../domain/model/stock.model.dart';

part 'stock.entity.g.dart';

@HiveType(typeId: 0)
class Stock extends HiveObject {
  @HiveField(0)
  String ticker;

  @HiveField(1)
  double dividendYield;

  @HiveField(2)
  double investedAmount;

  @HiveField(3)
  double currentPrice;

  Stock({
    required this.ticker,
    required this.dividendYield,
    required this.investedAmount,
    required this.currentPrice,
  });

  StockModel toModel() => StockModel(
        key: key,
        ticker: ticker,
        dividendYield: dividendYield,
        investedAmount: investedAmount,
        currentPrice: currentPrice,
      );

  factory Stock.fromModel(StockModel model) => Stock(
        ticker: model.ticker,
        dividendYield: model.dividendYield,
        investedAmount: model.investedAmount,
        currentPrice: model.currentPrice,
      );
}
