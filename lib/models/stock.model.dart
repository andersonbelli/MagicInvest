import 'package:hive/hive.dart';

part 'stock.model.g.dart';

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

  Stock copyWith({
    String? ticker,
    double? dividendYield,
    double? investedAmount,
    double? currentPrice,
  }) {
    return Stock(
      ticker: ticker ?? this.ticker,
      dividendYield: dividendYield ?? this.dividendYield,
      investedAmount: investedAmount ?? this.investedAmount,
      currentPrice: currentPrice ?? this.currentPrice,
    );
  }

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      ticker: json['ticker'] as String,
      dividendYield: (json['dividendYield'] as num).toDouble(),
      investedAmount: (json['investedAmount'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticker': ticker,
      'dividendYield': dividendYield,
      'investedAmount': investedAmount,
      'currentPrice': currentPrice,
    };
  }
}
