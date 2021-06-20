import 'dart:convert' as convert;
import 'package:escli/util.dart' as util;
import 'package:http/http.dart' as http;


void health(String baseHost) async {
  print(await getHealth(baseHost));
}

Future<String> getHealth(String baseHost) async {
  final response = await http.get(
      Uri.http('$baseHost', '/_cluster/health')).timeout(Duration(seconds: 1), onTimeout: () {
    return http.Response('', 503);
  }
  );
  if (response.statusCode == 200){
    return util.colorizeHealth(convert.jsonDecode(response.body)['status']);
  } else {
    return util.colorizeHealth('unreachable');
  }
}