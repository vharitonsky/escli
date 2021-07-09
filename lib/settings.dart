import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:escli/util.dart' as util;

const headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

void settings(String baseHost, List<String> arguments) async {
  var data;
  if (arguments.isNotEmpty) {
    final index = arguments[0];
    data = (await http.read(Uri.http('$baseHost', '/$index/_settings'),
            headers: headers))
        .toString();
  } else {
    data = (await http.read(Uri.http('$baseHost', '/_cluster/settings'),
            headers: headers))
        .toString();
  }
  util.pprintJson(data);
}

void set(String baseHost, List<String> arguments) async {
  var data;
  // index key value
  if (arguments.length == 3) {
    var index = arguments[0], key = arguments[1], value = arguments[2];
    var response = await http.put(Uri.http('$baseHost', '/$index/_settings'),
        headers: headers, body: jsonEncode({key: value}));
    data = response.body;
  } else if (arguments.length == 2) {
    var key = arguments[0], value = arguments[1];
    var response = await http.put(Uri.http('$baseHost', '/_cluster/settings'),
        headers: headers, body: jsonEncode({key: value}));
    data = response.body;
  } else {
    throw Exception("Index, key, value or key, value arguments required");
  }
  util.pprintJson(data);
}
