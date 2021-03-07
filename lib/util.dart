import 'dart:convert' as convert;

void pprintJson(String jsonData) {
  final encoder = convert.JsonEncoder.withIndent('  ');
  print(encoder.convert(convert.jsonDecode(jsonData)));
}