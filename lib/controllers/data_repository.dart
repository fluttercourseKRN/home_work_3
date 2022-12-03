import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  CollectionReference<Map<String, dynamic>> get _getCollectionPath {
    return FirebaseFirestore.instance.collection("infoRecords");
  }

  Future<List<InfoRecord>> getRecords() async {
    final startDate = DateUtils.dateOnly(_dateTime);
    final endDate = DateUtils.addDaysToDate(startDate, 1);

    final snapshot = await _getCollectionPath
        .where(
          "dateTime",
          isGreaterThanOrEqualTo: startDate,
          isLessThan: endDate,
        )
        .limit(_limit)
        .get();
    return snapshot.docs.map((e) => InfoRecord.fromMap(e.data())).toList();
  }

  Future<void> addNewRecord(InfoRecord record) async {
    await _getCollectionPath.doc(record.id).set(record.toMap());
    notifyListeners();
  }

  Future<void> removeRecord(String recordId) async {
    await _getCollectionPath.doc(recordId).delete();
    notifyListeners();
  }
}
