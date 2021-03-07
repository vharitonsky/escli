import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const headers = {'Accept': 'application/json'};

void indices(String baseHost, List<String> arguments) async {
  final response = await http.read(Uri.http(
      '$baseHost', '/_cat/indices'),
      headers: headers
  );
  final match = arguments.isNotEmpty ? arguments[0] : null;
  print(match);
  final indices = convert.jsonDecode(response);
  if (match == null) {
    for (final index in indices) {
      print("${index['index']}\t${index['health']}");
    }
  } else {
    for (final index in indices) {
      if (index['index'].toString().contains(match)) {
        print("${index['index']}\t${index['health']}");
      }
    }
  }
}