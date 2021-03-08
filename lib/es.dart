import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const headers = {'Accept': 'application/json'};

Future<List<String>> getIndexNames(String baseHost) async {
  final response = await http.read(Uri.http(
      '$baseHost', '/_cat/indices'),
      headers: headers
  );
  final List<dynamic> indices = convert.jsonDecode(response);
  final names = indices.map((i) => i['index'].toString()).toList();
  return names;
}
