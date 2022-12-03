import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../controllers/data_repository.dart';
import '../../model/info_record.dart';
import '../../utils/utils.dart';
import 'tile_base_info_record.dart';

class TileListInfoRecord extends StatelessWidget {
  const TileListInfoRecord({
    Key? key,
    required this.infoRecord,
  }) : super(key: key);

  final InfoRecord infoRecord;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(infoRecord.id),
      endActionPane:
          ActionPane(motion: const ScrollMotion(), extentRatio: 0.2, children: [
        SlidableAction(
          onPressed: (context) {
            DataRepository.read(context).removeRecord(infoRecord.id);
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        )
      ]),
      child: Card(
        elevation: 8,
        color: Colors.grey.withAlpha(Utils.opacity),
        child: TileBaseInfoRecord(
          infoRecord: infoRecord,
          dateFormat: Utils.dateTimeFormat,
        ),
      ),
    );
  }
}
