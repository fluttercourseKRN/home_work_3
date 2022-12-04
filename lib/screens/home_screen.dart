import 'package:blackout_tracker/controllers/blackout_manager.dart';
import 'package:blackout_tracker/controllers/data_repository.dart';
import 'package:blackout_tracker/model/info_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/device_info_manager.dart';
import '../widgets/app_drawer.dart';
import '../widgets/menu_widget.dart';
import '../widgets/tile_widgets/tile_current_info_record.dart';
import '../widgets/tile_widgets/tile_list_info_record.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BlackOut Tracker",
          style: GoogleFonts.kaushanScript(
              textStyle: Theme.of(context).textTheme.headline4),
        ),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          final newRecord = await DeviceInfoManager.getCurrentInfo();
          DataRepository.getRepository.addNewRecord(
            deviceId: BlackOutManager.getManager.deviceId,
            record: newRecord,
          );
        },
        child: const Text("Add Current Info"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              const Positioned.fill(
                child: FittedBox(
                  child: Icon(
                    FontAwesomeIcons.boltLightning,
                    color: Color.fromRGBO(255, 255, 255, 0.1),
                  ),
                ),
              ),
              Column(
                children: [
                  // Text(
                  //   "BlackOut Tracker",
                  //   style: GoogleFonts.kaushanScript(
                  //       textStyle: Theme.of(context).textTheme.headline3),
                  // ),
                  const SizedBox(height: 16),
                  const TileCurrentInfoRecord(),
                  const SizedBox(height: 16),
                  const MenuWidget(),
                  const Divider(),
                  Column(
                    children: const [],
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Saved status logs",
                    ),
                  ),
                  FutureBuilder<List<InfoRecord>>(
                    future: DataRepository.watch(context).getRecords(
                        deviceId: BlackOutManager.getManager.deviceId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        final infoRecords = snapshot.data ?? [];
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: infoRecords.length,
                          itemBuilder: (context, index) {
                            final infoRecord = infoRecords[index];
                            return TileListInfoRecord(infoRecord: infoRecord);
                          },
                        );
                      } else {
                        return const Center(
                          child: SpinKitWave(
                            color: Colors.orangeAccent,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
