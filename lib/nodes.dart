import 'dart:convert' as convert;
import 'package:escli/util.dart' as util;
import 'package:http/http.dart' as http;

const headers = {'Accept': 'application/json'};

void nodes(String baseHost, List<String> arguments) async {
  if(arguments.isEmpty){
      final response = await http.read(
          Uri.http('$baseHost', '/_cat/nodes'),
          headers: headers,
      );
      final nodes = convert.jsonDecode(response.toString());
      for (final node in nodes) {
        print("${node['ip']} ${node['name']}");
      }
  } else {
    final nodeName = arguments[0];
    final response = await http.read(
      Uri.http('$baseHost', '/_nodes/$nodeName/_all'),
      headers: headers,
    );
    util.pprintJson(response);
  }
}