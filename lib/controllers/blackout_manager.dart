import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import '../utils/duration_string_converter_ext.dart';
import 'data_repository.dart';
import 'device_info_manager.dart';

class BlackOutManager extends ChangeNotifier {
  BlackOutManager._internal();
  static final BlackOutManager _instance = BlackOutManager._internal();
  static BlackOutManager get getManager => _instance;

  static BlackOutManager read(BuildContext context) =>
      context.read<BlackOutManager>();
  static BlackOutManager watch(BuildContext context) =>
      context.watch<BlackOutManager>();

  ///MARK: Workmanager private method
  static const _createInfoRow = "createInfoRow";
  final Workmanager workmanager = Workmanager();
  static Future<void> init() async {
    _instance.autoSnapshotInterval = snapshotTimeRange.first;

    _instance.deviceId = await DeviceInfoManager.deviceId;
    // await _instance.workmanager.initialize(
    //   callbackDispatcher,
    // );
  }

  static Future<void> _callbackDispatcher() async {
    Workmanager().executeTask((taskName, inputData) async {
      switch (taskName) {
        case _createInfoRow:
          final newRecord = await DeviceInfoManager.getCurrentInfo();
          DataRepository.getRepository.addNewRecord(
            deviceId: _instance.deviceId,
            record: newRecord,
          );
          break;
      }
      return true;
    });
  }

  Future<void> _changeWorkmanagerStatus() async {
    await _cancelWorkmanager();
    if (_instance._isAutoSnapshotEnabled == true) {
      await _setUpWorkmanager(_instance._autoSnapshotInterval);
    }
  }

  Future<void> _cancelWorkmanager() async => await Workmanager().cancelAll();
  Future<void> _setUpWorkmanager(Duration timeInterval) async {
    await Workmanager().registerPeriodicTask(
      "1",
      _createInfoRow,
      frequency: timeInterval,
    );
  }

  ///MARK: Public API
  late final String deviceId;
  static const List<String> snapshotTimeRange = ["30m", "1h", "6h", "12h"];

  late Duration _autoSnapshotInterval;
  String get autoSnapshotInterval => _autoSnapshotInterval.convertToString();
  set autoSnapshotInterval(String value) {
    _autoSnapshotInterval = DurationStringConverter.fromString(value);
    _changeWorkmanagerStatus();
    notifyListeners();
  }

  bool _isAutoSnapshotEnabled = false;
  bool get isAutoSnapshotEnabled => _isAutoSnapshotEnabled;
  set isAutoSnapshotEnabled(bool value) {
    _isAutoSnapshotEnabled = value;
    _changeWorkmanagerStatus();
    notifyListeners();
  }
}
