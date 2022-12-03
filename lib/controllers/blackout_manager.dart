import 'data_repository.dart';
import 'device_info_manager.dart';

class BlackOutManager {
  BlackOutManager._internal();

  static final BlackOutManager _instance = BlackOutManager._internal();

  static BlackOutManager get getManager {
    return _instance;
  }

  static void init() {
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

  Future<void> createNewRecord() async {
    final newRecord = await DeviceInfoManager.getCurrentInfo();
    DataRepository.getRepository.addNewRecord(newRecord);
  }
}
