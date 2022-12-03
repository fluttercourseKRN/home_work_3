import 'package:uuid/uuid.dart';

class InfoRecord {
  final String id;
  final DateTime dateTime;
  final int chargingPercent;
  final bool isCharging;
  final bool isWirelessConnect;
  final bool isInternetConnect;

  InfoRecord({
    String? id,
    DateTime? dateTime,
    required this.chargingPercent,
    required this.isCharging,
    required this.isWirelessConnect,
    required this.isInternetConnect,
  })  : id = id ?? const Uuid().v4(),
        dateTime = dateTime ?? DateTime.now();

  @override
  String toString() {
    return 'InfoRecord{id: $id,'
        ' dateTime: $dateTime,'
        ' chargingPercent: $chargingPercent,'
        ' isCharging: $isCharging,'
        ' isWirelessConnect: $isWirelessConnect,'
        ' isInternetConnect: $isInternetConnect}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime,
      'chargingPercent': chargingPercent,
      'isCharging': isCharging,
      'isWirelessConnect': isWirelessConnect,
      'isInternetConnect': isInternetConnect,
    };
  }

  factory InfoRecord.fromMap(Map<String, dynamic> map) {
    return InfoRecord(
      id: map['id'] as String,
      dateTime: map['dateTime'].toDate(),
      chargingPercent: map['chargingPercent'] as int,
      isCharging: map['isCharging'] as bool,
      isWirelessConnect: map['isWirelessConnect'] as bool,
      isInternetConnect: map['isInternetConnect'] as bool,
    );
  }
}
