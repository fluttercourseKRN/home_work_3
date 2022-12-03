import 'package:flutter/material.dart';

class TileStatusElement extends StatelessWidget {
  const TileStatusElement({
    Key? key,
    required this.status,
    required this.icon,
  }) : super(key: key);

  final bool status;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Icon(icon,
              color: status
                  ? Colors.amber
                  : Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 10),
          Text(status ? "Yes" : "No")
        ],
      ),
    );
  }
}
