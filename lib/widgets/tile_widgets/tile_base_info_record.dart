import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../model/info_record.dart';
import 'title_status_element.dart';

class TileBaseInfoRecord extends StatelessWidget {
  const TileBaseInfoRecord({
    Key? key,
    required this.infoRecord,
    required this.dateFormat,
  }) : super(key: key);

  final InfoRecord infoRecord;
  final DateFormat dateFormat;
  Gradient _getColorForBatteryLevel(int batteryLevel) {
    if (batteryLevel < 25) {
      return LinearGradient(
        colors: [Colors.red, Colors.red.withAlpha(128)],
      );
    } else if (batteryLevel < 50) {
      return LinearGradient(
        colors: [Colors.amberAccent, Colors.amberAccent.withAlpha(128)],
      );
    } else if (batteryLevel < 75) {
      return LinearGradient(
        colors: [Colors.blue, Colors.blue.withAlpha(128)],
      );
    } else {
      return LinearGradient(
        colors: [Colors.green, Colors.green.withAlpha(128)],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // contentPadding: const EdgeInsets.all(2),
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _getColorForBatteryLevel(infoRecord.chargingPercent),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${infoRecord.chargingPercent}",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      title: FittedBox(
        child: Row(
          children: [
            TileStatusElement(
              icon: FontAwesomeIcons.plugCircleBolt,
              status: infoRecord.isCharging,
            ),
            TileStatusElement(
              icon: FontAwesomeIcons.wifi,
              status: infoRecord.isWirelessConnect,
            ),
            TileStatusElement(
              icon: FontAwesomeIcons.globe,
              status: infoRecord.isInternetConnect,
            ),
          ],
        ),
      ),
      subtitle: Text(
        "Snapshot date:   ${dateFormat.format(infoRecord.dateTime)}",
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.right,
      ),
    );
  }
}
