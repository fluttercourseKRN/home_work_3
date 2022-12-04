extension DurationStringConverter on Duration {
  String convertToString() {
    int allMinutes = inMinutes;
    StringBuffer buffer = StringBuffer();

    int hours = allMinutes ~/ 60;
    int minutes = allMinutes % 60;
    if (hours != 0) {
      buffer.writeAll([hours, "h"]);
    }
    if (minutes != 0) {
      buffer.writeAll([" ", minutes, "m"]);
    }
    return buffer.toString().trim();
  }

  static Duration fromString(String str) {
    int? hours;
    int? minutes;
    List<String> timeParts = str.split(" ");
    for (final part in timeParts) {
      if (part.endsWith("h")) {
        hours = int.tryParse(part.replaceFirst("h", ""));
      }
      if (part.endsWith("m")) {
        minutes = int.tryParse(part.replaceFirst("m", ""));
      }
    }
    return Duration(hours: hours ?? 0, minutes: minutes ?? 0);
  }
}
