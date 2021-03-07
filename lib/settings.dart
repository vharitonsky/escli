import 'package:http/http.dart' as http;
import 'package:escli/util.dart' as util;

const headers = {'Accept': 'application/json'};


void settings(String baseHost, List<String> arguments) async {
  var data;
  if (arguments.isNotEmpty) {
    final index = arguments[0];
    data = (await http.read(
        Uri.http('$baseHost', '/$index/_settings'), headers: headers
    )).toString();
  }else {
    data = (await http.read(
        Uri.http('$baseHost', '/_cluster/settings'), headers: headers
    )).toString();
  }
  util.pprintJson(data);
}