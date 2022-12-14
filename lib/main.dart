import 'package:blackout_tracker/controllers/blackout_manager.dart';
import 'package:blackout_tracker/controllers/data_repository.dart';
import 'package:blackout_tracker/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'controllers/device_info_manager.dart';
import 'utils/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await BlackOutManager.init();
  runApp(const MyApp());
}

@pragma('vm:entry-point')
void callbackDispatcher() async {
  Workmanager().executeTask((taskName, inputData) async {
    final newRecord = await DeviceInfoManager.getCurrentInfo();
    await DataRepository.saveDataLocally(newRecord);
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Blackout manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<DataRepository>.value(
              value: DataRepository.getRepository,
            ),
            ChangeNotifierProvider<BlackOutManager>.value(
              value: BlackOutManager.getManager,
            )
          ],
          child: const HomeScreen(),
        ));
  }
}
