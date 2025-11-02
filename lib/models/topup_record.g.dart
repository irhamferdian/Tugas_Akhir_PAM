// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topup_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TopUpRecordAdapter extends TypeAdapter<TopUpRecord> {
  @override
  final int typeId = 1;

  @override
  TopUpRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopUpRecord(
      apexCoins: fields[0] as int,
      idrAmount: fields[1] as double,
      currency: fields[2] as String,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TopUpRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.apexCoins)
      ..writeByte(1)
      ..write(obj.idrAmount)
      ..writeByte(2)
      ..write(obj.currency)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopUpRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
