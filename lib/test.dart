import 'dart:convert';

void main() {
  final date = DateTime.now();
  final js = json.encode(
    {"date": date},
    toEncodable: (object) {
      if (object is DateTime) {
        return object.toIso8601String();
      }
      return object;
    },
  );
  final map = json.decode(
    js,
    reviver: (key, value) {
      if (key == "date") {}
    },
  );
  print(js);
  print(map);
}
