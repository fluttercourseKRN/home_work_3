import 'package:blackout_tracker/model/info_record.dart';
import 'package:blackout_tracker/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../controllers/device_info_manager.dart';
import 'list_tile_info_record.dart';

class TileCurrentInfoRecord extends StatelessWidget {
  const TileCurrentInfoRecord({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InfoRecord>(
      stream: DeviceInfoManager.getRealtimeInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Current status",
                    ),
                  ),
                  ListTileInfoRecord(
                    dateFormat: Utils.dateTimeWithSecFormat,
                    infoRecord: snapshot.data!,
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SpinKitThreeInOut(
            color: Colors.blue,
          );
        }
      },
    );
  }
}
