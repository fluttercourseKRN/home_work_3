import 'package:blackout_tracker/model/device_stored_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import '../main.dart';
import '../utils/duration_string_converter_ext.dart';
import 'data_repository.dart';
import 'device_info_manager.dart';

class BlackOutManager extends ChangeNotifier {
  ///MARK: Public API
  late final String deviceId;
  static const List<String> snapshotTimeRange = ["15m", "30m", "1h", "12h"];

  late Duration _autoSnapshotInterval;
  String get autoSnapshotInterval => _autoSnapshotInterval.convertToString();
  set autoSnapshotInterval(String value) {
    _autoSnapshotInterval = DurationStringConverter.fromString(value);
    _updateState();
  }

  bool _isAutoSnapshotEnabled = false;
  bool get isAutoSnapshotEnabled => _isAutoSnapshotEnabled;
  set isAutoSnapshotEnabled(bool value) {
    _isAutoSnapshotEnabled = value;
    _updateState();
  }

  /// MARK: Singleton
  BlackOutManager._internal();
  static final BlackOutManager _instance = BlackOutManager._internal();
  static BlackOutManager get getManager => _instance;

  /// MARK: Provider method
  static BlackOutManager read(BuildContext context) =>
      context.read<BlackOutManager>();
  static BlackOutManager watch(BuildContext context) =>
      context.watch<BlackOutManager>();

  /// MARK: Workmanager
  static const _createInfoRow = "createInfoRow";

  static Future<void> init() async {
    await _initParams();
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  Future<void> _changeWorkmanagerState() async {
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
      initialDelay: timeInterval,
      frequency: timeInterval,
    );
  }

  /// MARK: Convenience method
  void _updateState() {
    _savePrefs();
    _changeWorkmanagerState();
    notifyListeners();
  }

  Future<void> _savePrefs() async {
    DataRepository.getRepository.saveDevicePrefs(
      deviceId: deviceId,
      prefs: DeviceStoredPreference(
        autoSnapshotInterval: autoSnapshotInterval,
        isAutoSnapshotEnabled: _isAutoSnapshotEnabled,
      ),
    );
  }

  static Future<void> _initParams() async {
    _instance.deviceId = await DeviceInfoManager.deviceId;

    final prefs = await DataRepository.getRepository
        .loadDevicePrefs(deviceId: _instance.deviceId);

    if (prefs != null) {
      _instance._autoSnapshotInterval =
          DurationStringConverter.fromString(prefs.autoSnapshotInterval);
      _instance._isAutoSnapshotEnabled = prefs.isAutoSnapshotEnabled;
    } else {
      _instance._autoSnapshotInterval =
          DurationStringConverter.fromString(snapshotTimeRange.first);
      _instance._isAutoSnapshotEnabled = false;
    }
  }
}
