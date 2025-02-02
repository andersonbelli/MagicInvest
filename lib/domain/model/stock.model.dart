import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/entity/stock.entity.dart';

part 'stock.model.freezed.dart';
part 'stock.model.g.dart';

@freezed
sealed class StockModel with _$StockModel {
  const factory StockModel({
    required String ticker,
    required double dividendYield,
    required double investedAmount,
    required double currentPrice,
    int? key,
  }) = _StockModel;

  factory StockModel.fromJson(Map<String, Object?> json) =>
      _$StockModelFromJson(json);

  factory StockModel.fromEntity(Stock entity) => StockModel(
        key: entity.key,
        ticker: entity.ticker,
        dividendYield: entity.dividendYield,
        investedAmount: entity.investedAmount,
        currentPrice: entity.currentPrice,
      );
}
