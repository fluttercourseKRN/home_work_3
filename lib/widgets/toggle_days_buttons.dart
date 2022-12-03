import 'package:flutter/material.dart';

class ToggleDaysButtons extends StatefulWidget {
  const ToggleDaysButtons({
    Key? key,
    required this.onChange,
    required this.defaultValue,
    required this.values,
  }) : super(key: key);

  final void Function(int days) onChange;
  final int defaultValue;
  final List<int> values;

  @override
  State<ToggleDaysButtons> createState() => _ToggleDaysButtonsState();
}

class _ToggleDaysButtonsState extends State<ToggleDaysButtons> {
  final Map<int, bool> toggles = {};

  @override
  void initState() {
    super.initState();
    assert(
      widget.values.contains(widget.defaultValue),
      "Impossible to set a default value that not contains in the values list",
    );

    for (final value in widget.values) {
      toggles[value] = value == widget.defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(4),
      onPressed: (index) {
        setState(() {
          final selectKey = toggles.keys.toList()[index];
          for (final key in toggles.keys) {
            if (key == selectKey) {
              toggles[key] = true;
            } else {
              toggles[key] = false;
            }
          }
          widget.onChange(selectKey);
        });
      },
      isSelected: [for (final value in toggles.values) value],
      children: [for (final key in toggles.keys) Text("$key")],
    );
  }
}
