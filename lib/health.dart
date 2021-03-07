import 'dart:convert' as convert;
import 'package:http/http.dart' as http;


void health(String baseHost) async {
  final response = await http.read(Uri.http('$baseHost', '/_cluster/health'));
  print(convert.jsonDecode(response.toString())['status']);
}