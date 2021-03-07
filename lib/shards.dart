import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const headers = {'Accept': 'application/json'};

void shards(String baseHost, List<String> arguments) async {
  final response = convert.jsonDecode(
      await http.read(
        Uri.http('$baseHost', '/_cat/shards'),
            headers: headers
        )
  );
  final index = arguments.isNotEmpty ? arguments[1] : null;
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