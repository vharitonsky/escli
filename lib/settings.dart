import 'dart:convert' as convert;
import 'package:http/http.dart' as http;


void settings(String baseHost, List<String> arguments) async {
  final index = arguments[0];
  final response = await http.read(Uri.http('$baseHost', '/$index/_settings'));
  final data = convert.jsonDecode(response.toString());
  final encoder = convert.JsonEncoder.withIndent('  ');
  print(encoder.convert(data));
}