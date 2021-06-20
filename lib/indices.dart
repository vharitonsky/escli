import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:escli/util.dart' as util;

const headers = {'Accept': 'application/json'};



void indices(String baseHost, List<String> arguments) async {
  final response = await http.read(Uri.http(
      '$baseHost', '/_cat/indices'),
      headers: headers
  );
  final match = arguments.isNotEmpty ? arguments[0] : null;
  final indices = convert.jsonDecode(response);
  if (match == null) {
    for (final index in indices) {
      print("${index['index']}\t${util.colorizeHealth(index['health'])}");
    }
  } else {
    print(match);
    for (final index in indices) {
      if (index['index'].toString().contains(match)) {
        print("\t ${index['index']}\t${util.colorizeHealth(index['health'])}");
      }
    }
  }
}

void index(String baseHost, List<String> arguments) async {
  var data;
  var subcommand = arguments[0];
  if(subcommand == 'create') {
    var name = arguments[1];
    var response = await http.put(
        Uri.http('$baseHost', '/$name'),
        headers: headers
    );
    data = response.body;
  } else if(subcommand == 'delete') {
    var name = arguments[1];
    var response = await http.delete(
        Uri.http('$baseHost', '/$name'),
        headers: headers
    );
    data = response.body;
  } else if(subcommand == 'open') {
    open(baseHost, arguments[1]);
  } else if(subcommand == 'close') {
    close(baseHost, arguments[1]);
  } else if(subcommand == 'reroute') {
    reroute(baseHost, arguments[1]);
  }
  util.pprintJson(data);
}

void close(String baseHost, index) async {
  var response = await http.post(
        Uri.http('$baseHost', '/$index/_close'),
        headers: headers
    );
  util.pprintJson(response.body);
}

void open(String baseHost, index) async {
  var response = await http.post(
      Uri.http('$baseHost', '/$index/_open'),
      headers: headers
  );
  util.pprintJson(response.body);
}

void reroute(String baseHost, index) async {
  var response = await http.post(
      Uri.http('$baseHost', '/$index/_reroute?retry_failed=true'),
      headers: headers
  );
  util.pprintJson(response.body);
}