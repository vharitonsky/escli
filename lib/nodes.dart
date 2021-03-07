import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const headers = {'Accept': 'application/json'};

void nodes(String baseHost, List<String> arguments) async {
  final response = await http.read(
      Uri.http('$baseHost', '/_cat/nodes'),
      headers: headers,
  );
  final nodes = convert.jsonDecode(response.toString());
  for (final node in nodes) {
    print("${node['ip']} ${node['name']}");
  }
}