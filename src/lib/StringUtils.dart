///
///  Created by Chris on 21/09/2018.
///
// ignore_for_file: omit_local_variable_types

String firstUpper(String value) {
  if (value == '') return '';
  return value[0].toUpperCase() + value.substring(1);
}

String firstLower(String value) {
  if (value == '') return '';
  return value[0].toLowerCase() + value.substring(1);
}

String left(String s, int count) {
  if (s.length <= count) {
    return s;
  } else {
    return s.substring(0, count);
  }
} // of left

String right(String s, int count) {
  if (s.length <= count) {
    return s;
  } else {
    return s.substring(s.length - count);
  }
} // of left

String plural(String s) {
  if (s.length < 1) return s;
  switch (right(s, 1)) {
    case 'y':
      return left(s, s.length - 1) + 'ies';
    case 's':
      return s + 'es';
    case 'h':
      if (right(s, 2) == 'ch' || right(s, 2) == 'sh') return s + 'es';
      break;
  }
  return s + 's';
} // of plural
