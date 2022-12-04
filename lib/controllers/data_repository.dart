import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/device_stored_preference.dart';
import '../model/info_record.dart';

class DataRepository extends ChangeNotifier {
  DataRepository._internal();

  static final DataRepository _instance = DataRepository._internal();

  static DataRepository get getRepository {
    return _instance;
  }

  static DataRepository read(BuildContext context) {
    return context.read<DataRepository>();
  }

  static DataRepository watch(BuildContext context) {
    return context.watch<DataRepository>();
  }

  static const List<int> limitDaysRange = [10, 20, 50];

  int _limit = limitDaysRange.first;
  int get limit => _limit;

  set limit(int value) {
    if (value != _limit) {
      _limit = value;
      notifyListeners();
    }
  }

  DateTime _dateTime = DateTime.now();
  DateTime get dateTime => _dateTime;
  set dateTime(DateTime value) {
    _dateTime = value;
    notifyListeners();
  }

  static const _basePath = "devices";
  static const _recordsPath = "infoRecords";
  DocumentReference<Map<String, dynamic>> _getDeviceDataPath(String deviceId) {
    return FirebaseFirestore.instance.collection(_basePath).doc(deviceId);
  }

  CollectionReference<Map<String, dynamic>> _getInfoRecordsPath(
      String deviceId) {
    return _getDeviceDataPath(deviceId).collection(_recordsPath);
  }

  Future<List<InfoRecord>> getRecords({required String deviceId}) async {
    final startDate = DateUtils.dateOnly(_dateTime);
    final endDate = DateUtils.addDaysToDate(startDate, 1);

    final snapshot = await _getInfoRecordsPath(deviceId)
        .where(
          "dateTime",
          isGreaterThanOrEqualTo: startDate,
          isLessThan: endDate,
        )
        .limit(_limit)
        .get();
    return snapshot.docs.map((e) => InfoRecord.fromMap(e.data())).toList();
  }

  Future<void> addNewRecord({
    required String deviceId,
    required InfoRecord record,
  }) async {
    await _getInfoRecordsPath(deviceId).doc(record.id).set(record.toMap());
    notifyListeners();
  }

  Future<void> removeRecord(
      {required String deviceId, required String recordId}) async {
    await _getInfoRecordsPath(deviceId).doc(recordId).delete();
    notifyListeners();
  }

  Future<DeviceStoredPreference?> loadDevicePrefs(String deviceId) async {
    return null;
  }

  Future<DeviceStoredPreference?> saveDevicePrefs(
      DeviceStoredPreference prefs) async {
    return null;
  }
}
