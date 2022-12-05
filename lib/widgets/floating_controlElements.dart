import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import '../controllers/blackout_manager.dart';
import '../controllers/data_repository.dart';
import '../controllers/device_info_manager.dart';

class FloatingControlElements extends StatelessWidget {
  const FloatingControlElements({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FutureBuilder<int>(
            future: DataRepository.watch(context).locallySavedCount,
            initialData: 0,
            builder: (context, snapshot) {
              final count = snapshot.data!;
              return Badge(
                showBadge: count != 0,
                badgeColor: Colors.redAccent,
                padding: const EdgeInsets.all(8),
                elevation: 8,
                position: BadgePosition.topStart(top: -2, start: -2),
                badgeContent: Text("${snapshot.data!}"),
                child: IconButton(
                  onPressed: count != 0
                      ? () async {
                          await DataRepository.read(context)
                              .synchronize(BlackOutManager.getManager.deviceId);
                        }
                      : null,
                  icon: const Icon(Icons.sync),
                  iconSize: 50,
                ),
              );
            }),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            final newRecord = await DeviceInfoManager.getCurrentInfo();

            // final value = await DataRepository.read(context).locallySavedCount;
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(SnackBar(content: Text("${value}")));
            // print(value);
            // await DataRepository.saveDataLocally(newRecord);

            DataRepository.getRepository.addNewRecord(
              deviceId: BlackOutManager.getManager.deviceId,
              record: newRecord,
            );
          },
          child: const Text("Add Current Info"),
        ),
      ],
    );
  }
}
