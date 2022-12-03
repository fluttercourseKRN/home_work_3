import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'data_repository.dart';
import 'device_info_manager.dart';

class BlackOutManager extends ChangeNotifier {
  BlackOutManager._internal();

  static final BlackOutManager _instance = BlackOutManager._internal();

  static BlackOutManager get getManager {
    return _instance;
  }

  static BlackOutManager read(BuildContext context) {
    return context.read<BlackOutManager>();
  }

  static BlackOutManager watch(BuildContext context) {
    return context.watch<BlackOutManager>();
  }

  static Future<void> init() async {
    _instance.autoSnapshotInterval = snapshotTimeRange.first;
    // Workmanager().initialize(callbackDispatcher);
    // Workmanager().registerPeriodicTask(
    //   "1",
    //   "createInfoRow",
    //   frequency: const Duration(minutes: 15),
    // );
  }

  // Callback what create new InfoRecord
  Future<void> callbackDispatcher() async {
    createNewRecord();
    // print("Hello");
  }

  static const List<String> snapshotTimeRange = ["30m", "1h", "6h", "12h"];
  late Duration _autoSnapshotInterval;

  String get autoSnapshotInterval {
    int allMinutes = _autoSnapshotInterval.inMinutes;
    StringBuffer buffer = StringBuffer();

    int hours = allMinutes ~/ 60;
    int minutes = allMinutes % 60;
    if (hours != 0) {
      buffer.writeAll([hours, "h"]);
    }
    if (minutes != 0) {
      buffer.writeAll([" ", minutes, "m"]);
    }
    return buffer.toString().trim();
  }

  set autoSnapshotInterval(String value) {
    int? hours;
    int? minutes;
    List<String> timeParts = value.split(" ");
    for (final part in timeParts) {
      if (part.endsWith("h")) {
        hours = int.tryParse(part.replaceFirst("h", ""));
      }
      if (part.endsWith("m")) {
        minutes = int.tryParse(part.replaceFirst("m", ""));
      }
    }
    _autoSnapshotInterval = Duration(hours: hours ?? 0, minutes: minutes ?? 0);
    notifyListeners();
  }

  bool _isAutoSnapshotEnabled = false;

  bool get isAutoSnapshotEnabled => _isAutoSnapshotEnabled;
  set isAutoSnapshotEnabled(bool value) {
    _isAutoSnapshotEnabled = value;
    notifyListeners();
  }

  Future<void> createNewRecord() async {
    final newRecord = await DeviceInfoManager.getCurrentInfo();
    DataRepository.getRepository.addNewRecord(newRecord);
  }
}
