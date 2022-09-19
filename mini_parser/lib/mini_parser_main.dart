int calculate() {
  return 6 * 7;
}

escape(String s) {
  return s.replaceAllMapped(RegExp(r'[.*+?^${}()|[\]\\]'), (x) {
    return "\\${x[0]}";
  });
}

Map<String, dynamic> loadModel(String s) {
  print('process ${escape(s)}');
  return {'todo': true};
}
