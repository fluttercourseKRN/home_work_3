import 'package:blackout_tracker/controllers/data_repository.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'toggle_days_buttons.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
            backgroundColor: MaterialStatePropertyAll(
              Colors.grey.withAlpha(Utils.opacity),
            ),
          ),
          onPressed: () async {
            final newDate = await showDatePicker(
              context: context,
              initialDate: DataRepository.read(context).dateTime,
              firstDate: DateTime.now().subtract(const Duration(days: 3650)),
              lastDate: DateTime.now(),
            );
            if (newDate != null) {
              DataRepository.getRepository.dateTime = newDate;
            }
          },
          child: Text(
              Utils.dateFormat.format(DataRepository.watch(context).dateTime)),
        ),
        ToggleDaysButtons(
          onChange: (value) {
            DataRepository.read(context).limit = value;
          },
          defaultValue: DataRepository.read(context).limit,
          values: DataRepository.limitDaysRange,
        )
      ],
    );
  }
}
