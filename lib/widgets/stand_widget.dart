import 'package:flutter/material.dart';

class StandWidget extends StatelessWidget {
  const StandWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const size = 40.0;
    return Row(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.amberAccent,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Stand with Ukraine',
          style: TextStyle(fontSize: size / 2),
        ),
      ],
    );
  }
}
