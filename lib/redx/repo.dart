import 'package:flutter_one/redx/state.dart';

List<RedxItem> loadThem(String q) {
  print("_loadThem _${q}_");
  return [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eigth",
    "nine",
    "ten"
  ]
      .where((s) => s.toLowerCase().contains(q.toLowerCase()))
      .map((s) => RedxItem(s))
      .toList();
}
