import 'dart:convert' as convert;
import 'package:escli/util.dart' as util;
import 'package:http/http.dart' as http;

const headers = {'Accept': 'application/json'};

void templates(String baseHost, List<String> arguments) async {
  if(arguments.isEmpty){
    final response = await http.read(
      Uri.http('$baseHost', '/_cat/templates'),
      headers: headers,
    );
    final nodes = convert.jsonDecode(response.toString());
    for (final node in nodes) {
      print("${node['ip']} ${node['name']}");
    }
  } else {
    final template = arguments[0];
    final response = await http.read(
      Uri.http('$baseHost', '/_templates/$template'),
      headers: headers,
    );
    util.pprintJson(response);
  }
}