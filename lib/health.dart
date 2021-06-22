import 'dart:convert' as convert;
import 'package:escli/util.dart' as util;
import 'package:http/http.dart' as http;


void health(String baseHost) async {
  print(util.colorizeHealth(await getHealth(baseHost)));
}

Future<util.ClusterHealth> getHealth(String baseHost) async {
  final response = await http.get(
      Uri.http('$baseHost', '/_cluster/health')).timeout(Duration(seconds: 1), onTimeout: () {
    return http.Response('', 503);
  }
  );
  if (response.statusCode == 200){
    var status;
    try {
      status = convert.jsonDecode(response.body)['status'];
    } catch (e) {
      return util.ClusterHealth.unreachable;
    }
    return util.parseHealth(status);
  } else {
    return util.ClusterHealth.unreachable;
  }
}