import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../model/info_record.dart';

class DeviceInfoManager {
  DeviceInfoManager._internal();

  static Future<String> get deviceId async {
    if (Platform.isAndroid) {
    } else if (Platform.isIOS) {
    } else {
      throw Exception("Unsupported platform");
    }
    return "";
  }

  static Stream<InfoRecord> getRealtimeInfo() async* {
    yield* Stream.periodic(
      const Duration(seconds: 1),
      (computationCount) {
        return getCurrentInfo();
      },
    ).asyncMap((event) async => await event);
  }

  static Future<InfoRecord> getCurrentInfo() async {
    final battery = Battery();

    final batteryLevel = await battery.batteryLevel;
    final batteryState = await battery.batteryState;
    final isWirelessConnect = await _isConnectToWifi();
    final connectStatus = await Connectivity().checkConnectivity();

    final newRecord = InfoRecord(
      chargingPercent: batteryLevel,
      isCharging: batteryState == BatteryState.charging,
      isWirelessConnect: isWirelessConnect,
      isInternetConnect: connectStatus != ConnectivityResult.none,
    );
    return newRecord;
  }

  static Future<bool> _isConnectToWifi() async {
    final networkInfo = NetworkInfo();
    final wifiName = await networkInfo.getWifiName();
    return wifiName != null;
  }
}
