import 'package:blackout_tracker/controllers/blackout_manager.dart';
import 'package:blackout_tracker/controllers/data_repository.dart';
import 'package:blackout_tracker/widgets/stand_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'app_toggle_buttons.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: DrawerHeader(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: FittedBox(
                          child: Icon(
                            FontAwesomeIcons.boltLightning,
                            color: Color.fromRGBO(255, 255, 255, 0.05),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BlackOut Tracker",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Settings",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Enable auto save for device"),
                  Switch(
                      value:
                          BlackOutManager.watch(context).isAutoSnapshotEnabled,
                      onChanged: (val) {
                        BlackOutManager.read(context).isAutoSnapshotEnabled =
                            val;
                      }),
                ],
              ),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Periodic backup time"),
                  const SizedBox(height: 8),
                  AppToggleButtons(
                    onChange: (value) {
                      BlackOutManager.read(context).autoSnapshotInterval =
                          value;
                    },
                    defaultValue:
                        BlackOutManager.getManager.autoSnapshotInterval,
                    values: BlackOutManager.snapshotTimeRange,
                  )
                ],
              ),
              const Spacer(),
              FutureBuilder<int>(
                  future: DataRepository.watch(context).locallySavedCount,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text("Locally saved count: ${snapshot.data!}");
                    }
                    return const Text("Locally saved count: 0");
                  }),
              Text("Device id: ${BlackOutManager.getManager.deviceId}"),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: StandWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
