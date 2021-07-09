import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const headers = {'Accept': 'application/json'};

Future<List<String>> getIndexNames(String baseHost) async {
  final response =
      await http.read(Uri.http('$baseHost', '/_cat/indices'), headers: headers);
  final List<dynamic> indices = convert.jsonDecode(response);
  final names = indices.map((i) => i['index'].toString()).toList();
  return names;
}

Future<List<String>> getNodeNames(String baseHost) async {
  final response =
      await http.read(Uri.http('$baseHost', '/_cat/nodes'), headers: headers);
  final List<dynamic> nodes = convert.jsonDecode(response);
  final names = nodes.map((n) => n['name'].toString()).toList();
  return names;
}

Future<List<String>> getTemplateNames(String baseHost) async {
  final response = await http.read(Uri.http('$baseHost', '/_cat/templates'),
      headers: headers);
  final List<dynamic> templates = convert.jsonDecode(response);
  final names = templates.map((t) => t['name'].toString()).toList();
  return names;
}
