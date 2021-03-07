import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main(List<String> arguments) async {
  final baseHost = arguments[0];
  final command = arguments[1];
  final headers = {'Accept': 'application/json'};
  if (command == 'health') {
    final response = await http.read(Uri.http('$baseHost', '/_cluster/health'));
    print(convert.jsonDecode(response.toString())['status']);
  } else if (command == 'indices') {
    final response = await http.read(Uri.http('$baseHost', '/_cat/indices'),
        headers: headers);
    final match = () {
      if (arguments.length > 2) {
        return arguments[2];
      }
    }();
    final indices = convert.jsonDecode(response);
    if (match != null) {
      for (final index in indices) {
        print("${index['index']}\t${index['health']}");
      }
    } else {
      for (final index in indices) {
        if (index['index'].toString().contains(match)) {
          print("${index['index']}\t${index['health']}");
        }
      }
    }
  } else if (command == 'shards') {
    final response = convert.jsonDecode(
        await http.read(
            Uri.http('$baseHost', '/_cat/shards'),
            headers: headers
        )
    );
    final index = () {
      if (arguments.length > 2) {
        return arguments[2];
      }
    }();
    if (index != null) {
      print(index);
      for (final shard in response) {
        if (shard['index'].toString().contains(index)) {
          print("\t${shard['node']} ${shard['shard']} ${shard['state']}");
        }
      }
    }else {
      for (final shard in response) {
        print("${shard['node']} ${shard['index']} ${shard['shard']} ${shard['state']}");
      }
    }
  }
}
