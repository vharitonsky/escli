import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:escli/util.dart' as util;

const headers = {'Accept': 'application/json'};

void stats(String baseHost, List<String> arguments) async {
  var response;
  if (arguments.isNotEmpty) {
    final node = arguments[0];
    response =
        await http.read(Uri.http('$baseHost', '/_cluster/stats/nodes/$node'));
  } else {
    response = await http.read(Uri.http('$baseHost', '/_cluster/stats'));
  }
  util.pprintJson(response.toString());
}
