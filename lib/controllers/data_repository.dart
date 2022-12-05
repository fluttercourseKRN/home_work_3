import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/device_stored_preference.dart';
import '../model/info_record.dart';

class DataRepository extends ChangeNotifier {
  /// MARK: Singleton
  DataRepository._internal();
  static final DataRepository _instance = DataRepository._internal();
  static DataRepository get getRepository => _instance;

  /// MARK: Provider method
  static DataRepository read(BuildContext context) =>
      context.read<DataRepository>();
  static DataRepository watch(BuildContext context) =>
      context.watch<DataRepository>();

  /// MARK: Local Storage
  static const localDataKey = "InfoRows";
  static Future<void> saveDataLocally(InfoRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final rows = prefs.getStringList(localDataKey) ?? [];
    final newDoc = json.encode(record.toMap(isoDate: true));
    rows.add(newDoc);
    await prefs.setStringList(localDataKey, rows);
    try {
      _instance.notifyListeners();
    } catch (e) {}
  }

  Future<int> get locallySavedCount async {
    final prefs = await SharedPreferences.getInstance();
    final rows = prefs.getStringList(localDataKey) ?? [];
    return rows.length;
  }

  Future<void> synchronize(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    final rows = prefs.getStringList(localDataKey) ?? [];
    if (rows.isEmpty) return;
    List<InfoRecord> records = rows
        .map((e) => InfoRecord.fromMap(jsonDecode(e), isoDate: true))
        .toList();
    FirebaseFirestore.instance.runTransaction((transaction) {
      for (final record in records) {
        _instance
            ._getInfoRecordsPath(deviceId)
            .doc(record.id)
            .set(record.toMap());
      }
      return Future.value(true);
    }).then(
      (value) async {
        await prefs.clear();
        _instance.notifyListeners();
      },
      onError: (e) => print(e),
    );

    // .then((_) => prefs.clear());
  }

  ///MARK: Public API
  static const List<int> limitDaysRange = [10, 20, 50];
  var askPermission = false;
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

  /// MARK: Firestore
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

  Future<void> removeRecord({
    required String deviceId,
    required String recordId,
  }) async {
    await _getInfoRecordsPath(deviceId).doc(recordId).delete();
    notifyListeners();
  }

  Future<DeviceStoredPreference?> loadDevicePrefs({
    required String deviceId,
  }) async {
    final snapshot = await _getDeviceDataPath(deviceId).get();
    if (snapshot.data() != null) {
      return DeviceStoredPreference.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<void> saveDevicePrefs({
    required String deviceId,
    required DeviceStoredPreference prefs,
  }) async {
    await _getDeviceDataPath(deviceId).set(prefs.toMap());
  }
}
