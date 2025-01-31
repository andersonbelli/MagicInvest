// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockAdapter extends TypeAdapter<Stock> {
  @override
  final int typeId = 0;

  @override
  Stock read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stock(
      ticker: fields[0] as String,
      dividendYield: fields[1] as double,
      investedAmount: fields[2] as double,
      currentPrice: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Stock obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.ticker)
      ..writeByte(1)
      ..write(obj.dividendYield)
      ..writeByte(2)
      ..write(obj.investedAmount)
      ..writeByte(3)
      ..write(obj.currentPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
