import 'package:hive/hive.dart';

part 'topup_record.g.dart';

@HiveType(typeId: 1)
class TopUpRecord extends HiveObject {
  @HiveField(0)
  final int apexCoins;

  @HiveField(1)
  final double idrAmount;

  @HiveField(2)
  final String currency;

  @HiveField(3)
  final DateTime timestamp;

  TopUpRecord({
    required this.apexCoins,
    required this.idrAmount,
    required this.currency,
    required this.timestamp,
  });
}
